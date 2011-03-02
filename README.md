#FrontFile

1 - Description
---------------

FrontFile is a set of scripts to with functions to find in files.
Currently there are two scripts:
- beater: search patterns in file;
- sentinel: search patterns in directory after call beater for each files; 

2 - Beater
----------
    Options:
    - file: name of target file;
    - patterns: pattern searched in file;
    - c: enable color in result;
    
    Example:
    `$ beater --file README.md --patterns sentinel`

3 - Sentinel
------------
    Options:
    - directory: name of target directory;
    - patterns: pattern searched in files;
    - extensions: pattern in name of files;
    - exclude: don't open files with this pattern;
    - v: enable verbose mode;

4 - Examples
------------

In the directory examples.
