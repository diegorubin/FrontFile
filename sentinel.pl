#!/usr/bin/perl
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

use Cwd;
use Cwd 'abs_path';
use Digest::SHA1  qw(sha1_hex);
use File::HomeDir qw(home);
use File::stat;
use Getopt::Long;

$result = GetOptions("directory=s" => \$directory,
                     "patterns=s" => \$patterns,
                     "extensions=s" => \$extensions,
                     "exclude=s" => \$exclude,
                     "x=s" => \$exclude,
                     "help" => \$help,
                     "recover" => \$recover,
                     "i" => \$ignorecase,
                     "v" => \$verbose,
                     "c" => \$color);

if(!$directory || !$patterns || $help){
     &help;
     exit 1;
}

my($beater_params) = "";
$beater_params = $beater_params." -c" if($color);
$beater_params = $beater_params." -i" if($ignorecase);

my(@files) = ();
my(@matched_files) = ();

if($recover){
     my($recover_file) = &init_recover(abs_path($directory).$patterns.$exclude.$extensions);
     my($date) = 0;
     foreach $mf (@matched_files) {push(@files,$mf);}
     @matched_files = ();
}

&read_directory($directory);

my($number_files) = $#files+1;
my($number_actual) = 0;

foreach $file (@files){
     if($verbose){
     	  $number_actual++;
          print "$number_actual/$number_files\r";
     }
     &call_beater($file);
}

if($recover){
	 &end_recover($recover_file);
}

exit;

# functions
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
               if (stat("$pwd/$f")) {
          	        $update = stat("$pwd/$f")->mtime;
                    push(@files,"$pwd/$f") if($update > $date);
               }
          }
     }
     closedir(DIR);
     chdir("..");
}

sub init_recover{
	 local($hashed_directory) = sha1_hex(@_);
	 local($home_directory) = home()."/.frontfile";
	 mkdir $home_directory unless(-e $home_directory);
	 
	 local($conf_dir) = $home_directory."/$hashed_directory";
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
     open($file, ">$conf_dir");

     print $file time();
     print $file "\n";

     return $file;
}

sub end_recover{
     foreach $tf (@matched_files){ print $file "$tf\n"; }
	 close($file);
}

sub call_beater{
	 local($target_file) = @_;
     local(@result) = `beater --file=$target_file --patterns=$patterns $beater_params`;
     if($#result+1){
     	  foreach $l (@result){ print $l}
     	  if($recover){
     	  	   push(@matched_files,$target_file);
          }
     }
}

sub help{
	 print "Usage: sentinel --directory dir --patterns pattern [--exclude|-x pattern] [ --extensions pattern] [-v][-c][-r][-i]\n";
}

