**\__FILE\__** and **\__LINE\__**

- - -

The **Exception.backtrace** method returns an array of strings containing this
information. The first element of this array is the location at which the exception
occurred, and each subsequent element is one stack frame higher.

The **Kernel.caller** method returns the current state of the call stack in the same form as
Exception.backtrace. With no argument, caller returns a stack trace whose first element
is the method that invoked the method that calls caller.

> caller[0] specifies the location from which the current method was invoked. You can also invoke
> caller with an argument that specifies how many stack frames to drop from the start
> of the backtrace. The default is 1, and caller(0)[0] specifies the location at which the
> caller method is invoked. This means, for example, that caller[0] is the same thing
> as caller(0)[1] and that caller(2) is the same as caller[1..-1].

- - -

If you want to include the main file (rather than just the files it requires) in
the hash, initialize it like this:

    SCRIPT_LINES__ = {__FILE__ => File.readlines(__FILE__)}

If you do this, then you can obtain the current line of source code anywhere in your
program with this expression:

    SCRIPT_LINES__[__FILE__][__LINE__-1]

- - -

Ruby allows you to trace assignments to global variables with Kernel.trace_var. Pass
this method a symbol that names a global variable and a string or block of code. When
the value of the named variable changes, the string will be evaluated or the block will
be invoked. When a block is specified, the new value of the variable is passed as an
argument. To stop tracing the variable, call Kernel.untrace_var. In the following
example, note the use of caller[1] to determine the program location at which the
variable tracing block was invoked:

    # Print a message every time $SAFE changes
    trace_var(:$SAFE) {|v|
      puts "$SAFE set to #{v} at #{caller[1]}"
    }

