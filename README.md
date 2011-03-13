#FrontFile

1 - Description
---------------

FrontFile is a set of scripts with functions to find in files.
Currently there are two scripts:

* beater: search patterns in file;
* sentinel: search patterns in directory after call beater for each files; 


2 - Beater
----------
Options:

* file: name of target file;
* patterns: pattern searched in file;
* c: enable color in result;

Example:
`$ beater --file README.md --patterns sentinel`

3 - Sentinel
------------
Options:

* directory: name of target directory
* patterns: pattern searched in files
* extensions: pattern in name of files
* exclude: don't open files with this pattern
* recover: save search after only changed files will be opened 
* v: enable verbose mode

Example:
`$ sentinel --directory . --patterns test --extensions .pl -v`

4 - Dependencies
----------------

Sentinel relies on the following modules:

* Digest::SHA1
* File::HomeDir 
* Getopt::Long
* File:stat
* Time::localtime

5 - Examples
------------

More examples can be found in /examples directory in repository.

6 - GUI
-------

A simple GUI was created using Gtk. The source code is in the directory gui / gFrontfile within the repository. Lacks many features, but can perform the basic operations of the sentinel.
To compile the gFrontFile beyond the basic tools (gcc, make, libc) must be installed font of GTK + 2.0 and gtksourceview. So to install it:

`$ ./configure`
`$ make`
`# make install`

And to run gui
`gfrontfile`


