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
use FrontFile qw(read_file);

GetOptions("file=s" => \$file,
     "patterns=s" => \$patterns,
     "help" => \$help,
     "c" => \$color);

if(!$patterns || !$file || $help){
	 &help;
	 exit 1;
}

read_file($file,$patterns,$color);
exit;

sub help{
	 print "Usage: beater --patterns pattern --file file [-c]\n";
}
