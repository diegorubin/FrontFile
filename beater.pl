# file: beater.pl
# Copyright (C) Diego Rubin 2011 <rubin.diego@gmail.com>
# 
# beater is free software.
# 
# You may redistribute it and/or modify it under the terms of the
# GNU General Public License, as published by the Free Software
# Foundation; either version 2 of the License, or (at your option)
# any later version.
# 
# beater is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with beater.pl.  If not, write to:
# 	The Free Software Foundation, Inc.,
# 	51 Franklin Street, Fifth Floor
# 	Boston, MA  02110-1301, USA.
#

#!/usr/bin/perl

use Getopt::Long;
use Term::ANSIColor;

$result = GetOptions("file=s" => \$file,
                     "patterns=s" => \$patterns,
                     "c" => \$color);
&read_file($file,$patterns);

exit;

sub read_file{
     local($_file) = $_[0];
     local(@_patterns) = split(/:::/,$_[1]);
     open(TARGET,"<$_file");

     my($print_name) = 1;
     my($number) = 0;
     while(<TARGET>){
     	  $number++;
          my($line) = $_;
          chomp($line);
          foreach $pattern (@_patterns){
          	   if($line =~ m/$pattern/){
          	   		if($print_name){
          	   			 if($color){
          	   			      print colored("in file $_file\n",'green');
                         }else{
          	   			      print "in file $_file\n";
                         }
                         $print_name = 0;
                    }
                    print "$number: ";
                    if($color){
                         my(@parts) = split(/$pattern/,$line);
                         my($last_position) = $#parts;
                         my($position) = 0;
                         foreach $exp (@parts){
                         	  print colored($exp,'white');
                         	  print colored($pattern,'red') unless $last_position == $position;
                         	  $position++;
                         }
                         print "\n";
                    }
                    else{
                    	 print $line."\n";
                    }
               }
          }
     }
}


