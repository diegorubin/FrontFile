#!/usr/bin/perl
#file:beater.pl

use Getopt::Long;
use Term::ANSIColor;

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


$result = GetOptions("file=s" => \$file,
                     "patterns=s" => \$patterns,
                     "c" => \$color);
read_file($file,$patterns);

