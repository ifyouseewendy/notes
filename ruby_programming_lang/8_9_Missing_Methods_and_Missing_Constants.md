+ **method_missing** private instance method of Object
+ **const_missing** private instance method of Module

- - -

a const_missing example

    # This module provides constants that define the UTF-8 strings for
    # all Unicode codepoints. It uses const_missing to define them lazily.
    # Examples:
    # copyright = Unicode::U00A9
    # euro = Unicode::U20AC
    # infinity = Unicode::U221E
    module Unicode
      # This method allows us to define Unicode codepoint constants lazily.
      def self.const_missing(name) # Undefined constant passed as a symbol
        # Check that the constant name is of the right form.
        # Capital U followed by a hex number between 0000 and 10FFFF.
        if name.to_s =~ /^U([0-9a-fA-F]{4,5}|10[0-9a-fA-F]{4})$/
          # $1 is the matched hexadecimal number. Convert to an integer.
          codepoint = $1.to_i(16)
          # Convert the number to a UTF-8 string with the magic of Array.pack.
          utf8 = [codepoint].pack("U")
          # Make the UTF-8 string immutable.
          utf8.freeze
          # Define a real constant for faster lookup next time, and return
          # the UTF-8 text for this time.
          const_set(name, utf8)
        else
          # Raise an error for constants of the wrong form.
          raise NameError, "Uninitialized constant: Unicode::#{name}"
        end
      end
    end

- - -

a method_missing example

    # Call the trace method of any object to obtain a new object that
    # behaves just like the original, but which traces all method calls
    # on that object. If tracing more than one object, specify a name to
    # appear in the output. By default, messages will be sent to STDERR,
    # but you can specify any stream (or any object that accepts strings
    # as arguments to <<).
    class Object
      def trace(name="", stream=STDERR)
        # Return a TracedObject that traces and delegates everything else to us.
        TracedObject.new(self, name, stream)
      end
    end

    # This class uses method_missing to trace method invocations and
    # then delegate them to some other object. It deletes most of its own
    # instance methods so that they don't get in the way of method_missing.
    # Note that only methods invoked through the TracedObject will be traced.
    # If the delegate object calls methods on itself, those invocations
    # will not be traced.
    class TracedObject
      # Undefine all of our noncritical public instance methods.
      # Note the use of Module.instance_methods and Module.undef_method.
      instance_methods.each do |m|
        m = m.to_sym # Ruby 1.8 returns strings, instead of symbols
        next if m == :object_id || m == :__id__ || m == :__send__
        undef_method m
      end

      # Initialize this TracedObject instance.
      def initialize(o, name, stream)
        @o = o # The object we delegate to
        @n = name # The object name to appear in tracing messages
        @trace = stream # Where those tracing messages are sent
      end

      # This is the key method of TracedObject. It is invoked for just
      # about any method invocation on a TracedObject.
      def method_missing(*args, &block)
        m = args.shift # First arg is the name of the method
        begin
          # Trace the invocation of the method.
          arglist = args.map {|a| a.inspect}.join(', ')
          @trace << "Invoking: #{@n}.#{m}(#{arglist}) at #{caller[0]}\n"
          # Invoke the method on our delegate object and get the return value.
          r = @o.send m, *args, &block
          # Trace a normal return of the method.
          @trace << "Returning: #{r.inspect} from #{@n}.#{m} to #{caller[0]}\n"
          # Return whatever value the delegate object returned.
          r
        rescue Exception => e
          # Trace an abnormal return from the method.
          @trace << "Raising: #{e.class}:#{e} from #{@n}.#{m}\n"
          # And re-raise whatever exception the delegate object raised.
          raise
        end
      end

      # Return the object we delegate to.
      def __delegate
        @o
      end
    end
