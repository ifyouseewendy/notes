**Binding**

A **Binding** object represents the state of Ruby’s variable bindings at some moment. The
**Kernel.binding** object returns the bindings in effect at the location of the call. You may
pass a Binding object as the second argument to eval, and the string you specify will
be evaluated in the context of those bindings.

    class Object # Open Object to add a new method
      def bindings # Note plural on this method
        binding # This is the predefined Kernel method
      end
    end

    class Test # A simple class with an instance variable
      def initialize(x); @x = x; end
    end

    t = Test.new(10) # Create a test object
    eval("@x", t.bindings) # => 10: We've peeked inside t

**eval** method allows you to pass a Proc object instead of a Binding object as the second argument.

**Ruby1.9** defines an eval method on Binding objects.

- - -

**instace_eval** and **class_eval** 

+ **instance_eval** defines **singleton methods** of the object. **class_eval** defines regular **instance methods**.
+ the important difference between these two methods and the global **eval** is that instance_eval and class_eval can accept a block of code to evaluate.

**Ruby1.9** defines two more evaluation methods: **instance_exec** and **class_exec** (and its alias, module_exec). The difference is that the exec methods accept arguments and pass them to the block. Thus, the block of code is evaluated in the context of the specified object, with parameters whose values come from outside the object.
