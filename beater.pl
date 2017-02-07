#!/usr/bin/perl
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


use Getopt::Long;
use Term::ANSIColor;

$result = GetOptions("file=s" => \$file,
                     "patterns=s" => \$patterns,
                     "help" => \$help,
                     "i" => \$ignore,
                     "c" => \$color);

if(!$patterns || !$file || $help){
	 &help;
	 exit 1;
}

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
               my($regexpattern) = ($ignore ? qr/$pattern/i : qr/$pattern/);
          	   if($line =~ m{$regexpattern}){
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
                    	 $line =~ s/($pattern)/-ceh-\1-ceh-/ig;
                         my(@parts) = split(/-ceh-/,$line);
                         my($position) = 0;
                         foreach $exp (@parts){
                         	  if($position%2){
                         	       print colored($exp,'red');
                              }
                              else{
                              	   print colored($exp,'white');
                              }
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

sub help{
	 print "Usage: beater --patterns pattern --file file [-c][-i]\n";
}
