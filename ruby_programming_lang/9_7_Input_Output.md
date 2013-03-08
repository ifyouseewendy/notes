The **File** class is a subclass of **IO**. IO objects also represent the
“standard input” and “standard output” streams used to read from and write to the
console. The stringio module in the standard library allows us to create a stream
wrapper around a string object. Finally, the socket objects used in networking
(described later in this chapter) are also IO objects.

    "r" Open for reading. The default mode.
    "r+" Open for reading and writing. Start at beginning of file. Fail if file does not exist.
    "w" Open for writing. Create a new file or truncate an existing one.
    "w+" Like "w", but allows reading of the file as well.
    "a" Open for writing, but append to the end of the file if it already exists.
    "a+" Like "a", but allows reads also.

- - -

Another way to obtain an IO object is to use the **stringio** library to read from or write
to a string.

    require "stringio"
    input = StringIO.open("now is the time") # Read from this string
    buffer = ""
    output = StringIO.open(buffer, "w") # Write into buffer

- - -

###\# Predefined Streams

    STDIN, STDOUT, STDERR, ARGV ( $< )

- - -

###\# Read from a Stream

**readline** and **gets** method differ only in their handling of **EOF**.

+ **gets** returns nil if it is invoked on a stream at EOF. 
+ **readline** instead raises an EOFError.

You can check whether a stream is already at EOF with the **eof?** method.

gets and readline implicitly set the global variable **$\_** to the **line of text they return**. A number of global methods, such as **print** , use $\_ if they are not explicitly passed an argument.

    lines = ARGF.readlines # Read all input, return an array of lines
    line = DATA.readline # Read one line from stream
    print l while l = DATA.gets # Read until gets returns nil, at EOF
    DATA.each {|line| print line } # Iterate lines from stream until EOF
    DATA.each_line # An alias for each
    DATA.lines # An enumerator for each_line: Ruby 1.9

    DATA.lineno = 0 # Start from line 0, even though data is at end of file
    DATA.readline # Read one line of data
    DATA.lineno # => 1
    $. # => 1: magic global variable, implicitly set

    # An alternative to text = File.read("data.txt")
    f = File.open("data.txt") # Open a file
    text = f.read # Read its contents as text
    c = f.readchar # Read it back againtext = f.read # Read its contents as text
    f.close # Close the file

    f = File.open("data", "r:binary") # Open data file for binary reads
    c = f.getc # Read the first byte as an integer
    f.ungetc(c) # Push that byte back
    c = f.readchar # Read it back again

    f.each_byte {|b| ... } # Iterate through remaining bytes
    f.bytes # An enumerator for each_byte: Ruby 1.9

- - -

###\# Write to a Stream

    o = STDOUT
    # String output
    o << x # Output x.to_s
    o << x << y # May be chained: output x.to_s + y.to_s
    o.print # Output $_ + $\
    o.print s # Output s.to_s + $\
    o.print s,t # Output s.to_s + t.to_s + $\
    o.printf fmt,*args # Outputs fmt%[args]
    o.puts # Output newline
    o.puts x # Output x.to_s.chomp plus newline
    o.puts x,y # Output x.to_s.chomp, newline, y.to_s.chomp, newline
    o.puts [x,y] # Same as above
    o.write s # Output s.to_s, returns s.to_s.length
    o.syswrite s # Low-level version of write

- - -

###\# Random Access Methods

    f = File.open("test.txt")
    f.pos # => 0: return the current position in bytes
    f.pos = 10 # skip to position 10
    f.tell # => 10: a synonym for pos
    f.rewind # go back to position 0, reset lineno to 0, also
    f.seek(10, IO::SEEK_SET) # Skip to absolute position 10
    f.seek(10, IO::SEEK_CUR) # Skip 10 bytes from current position
    f.seek(-10, IO::SEEK_END) # Skip to 10 bytes from end
    f.seek(0, IO::SEEK_END) # Skip to very end of file
    f.eof? # => true: we're at the end

- - -

###\# Closing, Flushing, and Testing Streams

    out.print 'wait>' # Display a prompt
    out.flush # Manually flush output buffer to OS
    sleep(1) # Prompt appears before we go to sleep

    out.sync = true # Automatically flush buffer after every write
    out.sync = false # Don't automatically flush
    out.sync # Return current sync mode
    out.fsync # Flush output buffer and ask OS to flush its buffers
    # Returns nil if unsupported on current platform

    f.eof? # true if stream is at EOF
    f.closed? # true if stream has been closed
    f.tty? # true if stream is interactive
