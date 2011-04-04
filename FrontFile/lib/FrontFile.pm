package FrontFile;

use 5.010001;
use strict;
use warnings;

use Term::ANSIColor;
use Cwd;
use File::stat;

use Digest::SHA1  qw(sha1_hex);
use File::HomeDir qw(home);

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use FrontFile ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
     read_file
     read_directory
);

our $VERSION = '1.1';

# Global Options
my($exclude);
my($extensions);
my($date) = 0;
my($update);
my($file);
my($recover);
my($color);
my($pattern);

my(@files);
my(@matched_files);


# This method find a pattern in file
# Args: filename, pattern, output_with_color
sub read_file{
     my($_file) = $_[0];
     my(@_patterns) = split(/:::/,$_[1]);
     my($color) = $_[2];

     my($result);

     open(my $target,'<',$_file) || die "Cannot open $_file\n";

     my($print_name) = 1;
     my($number) = 0;
     while(my $line = <$target>){

     	  $number++;
          chomp($line);
          my($pattern);
          foreach $pattern (@_patterns){
          	   if($line =~ m/$pattern/){
          	   		if($print_name){
          	   			 if($color){
          	   			      $result = colored("in file $_file\n",'green');
                         }else{
          	   			      $result = "in file $_file\n";
                         }
                         $print_name = 0;
                    }
                    $result = $result."$number: ";
                    if($color){
                    	 $line =~ s/($pattern)/-ceh-$1-ceh-/g;
                         my(@parts) = split(/-ceh-/,$line);
                         my($position) = 0;
                         foreach my $exp (@parts){
                         	  if($position%2){
                         	       $result = $result.colored($exp,'red');
                              }
                              else{
                              	   $result = $result.colored($exp,'white');
                              }
                         	  $position++;
                         }
                         $result = $result."\n";
                    }
                    else{
                    	 $result = $result.$line."\n";
                    }
               }
          }
     }
     $result;
}

# This method find pattern file name in directory
# Args: directory
sub read_directory {
     my($directory) = $_[0];
     chdir($directory) || die "Cannot chdir to $directory\n";
     my($pwd) = getcwd;
     local(*DIR);
     opendir(DIR, ".");
     while (my($f)= readdir(DIR)) {
          next if ($f eq "." || $f eq "..");
          next if ($extensions && (-f $f) && ($f !~ m/$extensions/));
          next if ($exclude && ($f =~ m/$exclude/));
          if (-d $f) {
               &read_directory($f);
          }
          else{
               $update = stat("$pwd/$f")->mtime;
               push(@files,"$pwd/$f") if($update > $date);
          }
     }
     closedir(DIR);
     chdir("..");
}

# This method init configurations for recover search
# Args: string 
sub init_recover{
	 my($hashed_directory) = sha1_hex(@_);
	 my($home_directory) = home()."/.frontfile";
	 mkdir $home_directory unless(-e $home_directory);
	 
	 my($conf_dir) = $home_directory."/$hashed_directory";
	 if(-e $conf_dir){
	 	  open(FILE,"$conf_dir");
	 	  while(<FILE>){
	 	  	   chomp($_);
	 	  	   unless($date){
	 	  	   		$date = $_;
               }
               else{
               		push(@matched_files,$_);
               }
          }
	 	  close(FILE);
     }
     open($file, ">", $conf_dir);

     print $file time();
     print $file "\n";

     return $file;
}


# This method close file with search configurations
sub end_recover{
     foreach my $tf (@matched_files){ print $file "$tf\n"; }
	 close($file);
}

# This method read a file
# Args: target_file
sub call_beater{
     my($target_file) = @_;
     my(@result) = read_file($target_file,$pattern,$color);
     if($#result+1){
     	  foreach my $l (@result){ print $l}
     	  if($recover){
     	  	   push(@matched_files,$target_file);
          }
     }
}

1;
__END__
=head1 FrontFile

FrontFile - Perl module for search in files

=head1 SYNOPSIS

  use FrontFile;
  

=head1 DESCRIPTION

Stub documentation for FrontFile, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Diego Rubin, (rubin.diego@gmail.com)

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Diego Rubin

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
