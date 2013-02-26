**require** and **load** are global functions defined in **Kernel**, but are used like language keywords. Both can **load and execute** a specified file of Ruby source code.

load and require search file relative to the directories of Ruby\'s load path.

- in addition to loading source code, **require** can also load binary extensions to Ruby.
- **load** expects a complete filename including an extension. require is usually passed a library name, with no extension, rather than a filename.
- **load** can load the same file multiple times. **require** tries to prevent multiple loads of the same file. **require** keeps track of the files that have been loaded by appending them to the global array `$"` (also known as **$LOADED_FEATURES**). load does not do this.
- **load** loads the specified file at the current $SAFE level. **require** loads the specified library with $SAFE set to 0.

- - -

**$LOAD_PATH and $:**

in Ruby1.8

    # site-specific libraries first
    /usr/lib/site_ruby/1.8
    /usr/lib/site_ruby/1.8/i386-linux
    /usr/lib/site_ruby
    /usr/lib/ruby/1.8
    /usr/lib/ruby/1.8/i386-linux
    .

in Ruby1.9

    # gems => site_ruby => vendor_ruby => standard library
    # vendor_ruby: customizations provided by operating system vendors 
    /usr/local/lib/ruby/gems/1.9/gems/rake-0.7.3/lib
    /usr/local/lib/ruby/gems/1.9/gems/rake-0.7.3/bin
    /usr/local/lib/ruby/site_ruby/1.9
    /usr/local/lib/ruby/site_ruby/1.9/i686-linux
    /usr/local/lib/ruby/site_ruby
    /usr/local/lib/ruby/vendor_ruby/1.9
    /usr/local/lib/ruby/vendor_ruby/1.9/i686-linux
    /usr/local/lib/ruby/vendor_ruby
    /usr/local/lib/ruby/1.9
    /usr/local/lib/ruby/1.9/i686-linux
    .

some examples

    # Remove the current directory from the load path
    $:.pop if $:.last == '.'
    # Add the installation directory for the current program to
    # the beginning of the load path
    $LOAD_PATH.unshift File.expand_path($PROGRAM_NAME)
    # Add the value of an environment variable to the end of the path
    $LOAD_PATH << ENV['MY_LIBRARY_DIRECTORY']

- - -

> Files loaded with **load or require** are executed in a new **top-level** scope that is different
> from the one in which load or require was invoked. The loaded file can see all global
> variables and constants that have been defined at the time it is loaded, but it does not
> have access to the local scope from which the load was initiated.

> If the **load** called with a second argument that is anything other than nil or false, then it “wraps”
> the specified file and loads it into an anonymous module.  
> This means that the loaded file cannot affect the global namespace; any constants (including classes and modules)
> it defines are trapped within the anonymous module.

- - -

The **autoload** methods of Kernel and Module allow **lazy loading** of files on an as-needed
basis. The global autoload function allows you to register the name of an undefined
constant (typically a class or module name) and a name of the library that defines it.
When that constant is first referenced, the named library is loaded using require.

    # Require 'socket' if and when the TCPSocket is first used
    autoload :TCPSocket, "socket"

The Module class defines its own version of autoload to work with constants nested within another module. Use **autoload?** or **Module.autoload?** to test whether a reference to a constant will cause a file to be loaded. This method expects a symbol argument.
