#!/usr/bin/perl
#file:sentinel.pl

use Getopt::Long;
use Cwd;
$result = GetOptions("directory=s" => \$directory,
                     "patterns=s" => \$patterns,
                     "extensions=s" => \$extensions,
                     "v" => \$verbose);
my(@files) = ();
&read_directory($directory);

my($number_files) = $#files+1;
my($number_actual) = 0;
foreach $file (@files){
     if($verbose){
     	  $number_actual++;
          print "$number_actual/$number_files\r";
     }
     print `beater --file=$file --patterns=$patterns`;
}

exit;

sub read_directory {
     local($directory) = @_;
     chdir($directory) || die "Cannot chdir to $directory\n";
     local($pwd) = getcwd;
     local(*DIR);
     opendir(DIR, ".");
     while ($f=readdir(DIR)) {
          next if ($f eq "." || $f eq "..");
          next if ($extensions && (-f $f) && ($f !~ m/$extensions/));
          if (-d $f) {
               &read_directory($f);
          }
          else{
          	   push(@files,"$pwd/$f");
          }
     }
     closedir(DIR);
     chdir("..");
}



