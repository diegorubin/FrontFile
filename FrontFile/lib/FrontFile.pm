package FrontFile;

use 5.010001;
use strict;
use warnings;

use Term::ANSIColor;


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
	
);

our $VERSION = '1.1';


# This method find a pattern in file
# Args: filename, pattern, output_with_color
sub read_file{
     my($_file) = $_[0];
     my(@_patterns) = split(/:::/,$_[1]);
     my($color) = $_[2];

     my($result);

     open(my $target,'<',$_file);

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
