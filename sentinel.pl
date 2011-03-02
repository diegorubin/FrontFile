# file: sentinel.pl
# Copyright (C) Diego Rubin 2011 <rubin.diego@gmail.com>
# 
# sentinel is free software.
# 
# You may redistribute it and/or modify it under the terms of the
# GNU General Public License, as published by the Free Software
# Foundation; either version 2 of the License, or (at your option)
# any later version.
# 
# sentinel is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with sentienl.pl.  If not, write to:
# 	The Free Software Foundation, Inc.,
# 	51 Franklin Street, Fifth Floor
# 	Boston, MA  02110-1301, USA.
#
#!/usr/bin/perl

use Getopt::Long;
use Cwd;
$result = GetOptions("directory=s" => \$directory,
                     "patterns=s" => \$patterns,
                     "extensions=s" => \$extensions,
                     "exclude=s" => \$exclude,
                     "v" => \$verbose,
                     "c" => \$color);
my(@files) = ();
&read_directory($directory);

my($number_files) = $#files+1;
my($number_actual) = 0;
foreach $file (@files){
     if($verbose){
     	  $number_actual++;
          print "$number_actual/$number_files\r";
     }
     print `beater --file=$file --patterns=$patterns -c`;
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
          next if ($exclude && ($f =~ m/$exclude/));
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



