#!/usr/bin/perl
#file:sentinel.pl

use Getopt::Long;
use Cwd;
$result = GetOptions("directory=s" => \$directory,
                     "patterns=s" => \$patterns,
                     "extensions=s" => \$extensions);
my(@files) = ();
&read_directory($directory);

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
               print `beater --file=$pwd/$f --patterns=$patterns`;
          }
     }
     closedir(DIR);
     chdir("..");
}



