###\# File and Directory Names

    full = '/home/matz/bin/ruby.exe'

    file=File.basename(full) # => 'ruby.exe': just the local filename
    File.basename(full, '.exe') # => 'ruby': with extension stripped
    dir=File.dirname(full) # => '/home/matz/bin': no / at end
    File.dirname(file) # => '.': current directory

    File.split(full) # => ['/home/matz/bin', 'ruby.exe']
    File.extname(full) # => '.exe'
    File.join('home','matz') # => 'home/matz': relative
    File.join('','home','matz') # => '/home/matz': absolute

**File.expand_path** method converts a relative path to a fully qualified path. If it begins with a Unixstyle
~, the directory is relative to the current user or specified user’s home directory.

    Dir.chdir("/usr/bin") # Current working directory is "/usr/bin"
    File.expand_path("ruby") # => "/usr/bin/ruby"
    File.expand_path("~/ruby") # => "/home/david/ruby"
    File.expand_path("ruby", "/usr/local/bin") # => "/usr/local/bin/ruby"
    File.expand_path("ruby", "../local/bin") # => "/usr/local/bin/ruby"
    File.expand_path("ruby", "~/bin") # => "/home/david/bin/ruby"

**File.identical?** method tests whether two filenames refer to the same file.

    File.identical?("ruby", "ruby") # => true if the file exists
    File.identical?("ruby", "/usr/bin/ruby") # => true if CWD is /usr/bin
    File.identical?("ruby", "../bin/ruby") # => true if CWD is /usr/bin
    File.identical?("ruby", "ruby1.9") # => true if there is a link

**File.fnmatch** tests whether a filename matches a specified pattern. The pattern
is not a regular expression, but is like the file-matching patterns used in shells.

  + "?" matches a single character.
  + "\*" matches any number of characters. And “**” mat any number of directory level
  + Characters in square brackets are alternatives, as in regular expressions. fnmatch does not allow alternatives in curly braces (as the Dir.glob method described below does). 
  + fnmatch should usually be invoked with a third argument of **File::FNM_PATHNAME**, which prevents “*” from matching “/”. **File::FNM_DOTMATCH** if you want “hidden” files and directories whose names begin with “.” to match.

        File.fnmatch("*.rb", "hello.rb") # => true
        File.fnmatch("*.[ch]", "ruby.c") # => true
        File.fnmatch("*.[ch]", "ruby.h") # => true
        File.fnmatch("?.txt", "ab.txt") # => false
        flags = File::FNM_PATHNAME | File::FNM_DOTMATCH
        File.fnmatch("lib/*.rb", "lib/a.rb", flags) # => true
        File.fnmatch("lib/*.rb", "lib/a/b.rb", flags) # => false
        File.fnmatch("lib/**/*.rb", "lib/a.rb", flags) # => true
        File.fnmatch("lib/**/*.rb", "lib/a/b.rb", flags) # => true

- - -

###\# Listing Directories

**Dir.entries** method and the **Dir.foreach** iterator

    # Get the names of all files in the config/ directory
    filenames = Dir.entries("config") # Get names as an array
    Dir.foreach("config") {|filename| ... } # Iterate names

**Dir.[]** operator

    Dir['*.data'] # Files with the "data" extension
    Dir['ruby.*'] # Any filename beginning with "ruby."
    Dir['?'] # Any single-character filename
    Dir['*.[ch]'] # Any file that ends with .c or .h
    Dir['*.{java,rb}'] # Any file that ends with .java or .rb
    Dir['*/*.rb'] # Any Ruby program in any direct sub-directory
    Dir['**/*.rb'] # Any Ruby program in any descendant directory

**Dir.glob** is more powerful.

+ by default, this method works like Dir[], but if passed a block, it yields the matching filenames one at a time rather than returning an array.
+ the glob method accepts an optional second argument(eg. File::FNM_DOTMATCH).

    Dir.glob('*.rb') {|f| ... } # Iterate all Ruby files
    Dir.glob('*') # Does not include names beginning with '.'
    Dir.glob('*',File::FNM_DOTMATCH) # Include . files, just like Dir.entries

**Dir.getwd / Dir.pwd**

    puts Dir.getwd # Print current working directory
    Dir.chdir("..") # Change CWD to the parent directory
    Dir.chdir("../sibling") # Change again to a sibling directory
    Dir.chdir("/home") # Change to an absolute directory
    Dir.chdir # Change to user's home directory
    home = Dir.pwd # pwd is an alias for getwd

- - -

###\# Testing Files

    f = "/usr/bin/ruby" # A filename for the examples below

    # File existence and types.
    File.exist?(f) # Does the named file exist? Also: File.exists?
    File.file?(f) # Is it an existing file?
    File.directory?(f) # Or is it an existing directory?
    File.symlink?(f) # Either way, is it a symbolic link?

    # File size methods. Use File.truncate to set file size.
    File.size(f) # File size in bytes.
    File.size?(f) # Size in bytes or nil if empty file.
    File.zero?(f) # True if file is empty.

    # File permissions. Use File.chmod to set permissions (system dependent).
    File.readable?(f) # Can we read the file?
    File.writable?(f) # Can we write the file? No "e" in "writable"
    File.executable?(f) # Can we execute the file?
    File.world_readable?(f) # Can everybody read it? Ruby 1.9.
    File.world_writable?(f) # Can everybody write it? Ruby 1.9.

    # File times/dates. Use File.utime to set the times.
    File.mtime(f) # => Last modification time as a Time object
    File.atime(f) # => Last access time as a Time object

    File.ftype("/usr/bin/ruby") # => "link"
    File.ftype("/usr/bin/ruby1.9") # => "file"
    File.ftype("/usr/lib/ruby") # => "directory"
    File.ftype("/usr/bin/ruby3.0") # SystemCallError: No such file or directory

**stat** follows symbolic links; **lstat** returns information about the link itself. These methods return a **File::Stat** object, which has instance methods with the same names (but without arguments) as the class methods of File.

    s = File.stat("/usr/bin/ruby")
    s.file? # => true
    s.directory? # => false
    s.ftype # => "file"
    s.readable? # => true
    s.writable? # => false
    s.executable? # => true
    s.size # => 5492
    s.atime # => Mon Jul 23 13:20:37 -0700 2007

- - -

###\# Creating, Deleting, and Renaming Files and Directories

    # Create (or overwrite) a file named "test"
    File.open("test", "w") {}

    File.rename("test", "test.old") # Current name, then new name
    File.symlink("test.old", "oldtest") # Link target, link name
    File.link("test.old", "test2") # Link target, link name
    File.delete("test2") # May also be called with multiple args
    File.unlink("oldtest") # to delete multiple named files

    f = "log.messages" # Filename
    atime = mtime = Time.now # New access and modify times
    File.truncate(f, 0) # Erase all existing content
    File.utime(atime, mtime, f) # Change times
    File.chmod(0600, f) # Unix permissions -rw-------; note octal arg

    Dir.mkdir("temp") # Create a directory
    File.open("temp/f", "w") {} # Create a file in it
    File.open("temp/g", "w") {} # Create another one
    File.delete(*Dir["temp/*"]) # Delete all files in the directory
    Dir.rmdir("temp") # Delete the directory
