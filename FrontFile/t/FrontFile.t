# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl FrontFile.t'

#########################

use Test::More tests => 3;
BEGIN { use_ok('FrontFile')};

is(read_file("README","Diego Rubin",0),"in file README\n34: Copyright (C) 2011 by Diego Rubin\n", "read copyright from README");


is(read_directory("."),"in file README\n34: Copyright (C) 2011 by Diego Rubin\n", "read copyright from directory");


#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.



