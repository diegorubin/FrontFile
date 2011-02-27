#!/usr/bin/perl
#file:beater.pl

use Getopt::Long;

sub read_file{
     my($_file) = $_[0];
     my(@_patterns) = split(/:::/,$_[1]);
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
          	   			 print "in file $_file\n\n";
                         $print_name = 0;
                    }
                    print " $number: $line \n";
               }
          }
     }
}

$result = GetOptions("file=s" => \$file,"patterns=s" => \$patterns);
read_file($file,$patterns);

