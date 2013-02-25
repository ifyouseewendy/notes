Objects are created in three ways:
  - initialize
  - dup, clone
  - Marshal.load

- - -

Every class inherits the class method **new**. It delegates these two jobs to the **allocate** and **initialize** methods, respectively.

**allocate** is an instance method of Class, and it is inherited by all class objects.

In fact, the return value of **initialize** is ignored. Ruby implicitly makes the **initialize** method private, which means that you cannot explicitly invoke it on an object.

- - -

- **Class#new** is inherited by all class objects, becoming a class method of the class, and is used to create and initialize new instances.
- **Class::new** is the Class class’ own version of the method, and it can be used to create new classes.

Code below relies on **new** and **initialize**, and makes **new** private, to make **Factory** methods:

    class Point
      # Define an initialize method as usual...
      def initialize(x,y) # Expects Cartesian coordinates
        @x,@y = x,y
      end

      # But make the factory method new private
      # note: this new is Point::new, and Class#new
      private_class_method :new

      def Point.cartesian(x,y) # Factory method for Cartesian coordinates
        new(x,y) # We can still call new from other class methods
      end

      def Point.polar(r, theta) # Factory method for polar coordinates
        new(r*Math.cos(theta), r*Math.sin(theta))
      end
    end

- - -

**dup** and **clone** copy all the instance variables and the taintedness of the receiver object to the newly allocated object. **clone** takes this copying a step further than **dup** -- it also copies _singleton methods_ of the receiver object and freezes
the copy object if the original is _frozen_.

If a class defines a method named **initialize_copy**, then clone and dup will invoke that method on the copied object after copying the instance variables from the original. (clone calls initialize_copy before freezing the copy object, so that initialize_copy is still allowed to modify it.)

Like initialize, Ruby ensures that initialize_copy is always private.

Some classes, such as those that define enumerated types, may want to strictly limit the number of instances that exist.

    class Season
      NAMES = %w{ Spring Summer Autumn Winter } # Array of season names
      INSTANCES = [] # Array of Season objects

      def initialize(n) # The state of a season is just its
        @n = n # index in the NAMES and INSTANCES arrays
      end

      def to_s # Return the name of a season
        NAMES[@n]
      end

      # This code creates instances of this class to represent the seasons
      # and defines constants to refer to those instances.
      # Note that we must do this after initialize is defined.
      NAMES.each_with_index do |name,index|
        instance = new(index) # Create a new instance
        INSTANCES[index] = instance # Save it in an array of instances
        const_set name, instance # Define a constant to refer to it
      end

      # Now that we have created all the instances we'll ever need, we must
      # prevent any other instances from being created
      private_class_method :new,:allocate # Make the factory methods private
      private :dup, :clone # Make copying methods private
    end

- - -

A third way that objects are created is when **Marshal.load** is called to re-create objects previously marshaled (or “serialized”) with Marshal.dump. Marshal.dump saves the class of an object and recursively marshals the value of each of its instance variables.

If you define a custom marshal_dump method, you must define a matching marshal_load method, of course. marshal_load will be invoked on a newly allocated (with allocate) but uninitialized instance of the class.

\_dump is an instance method that must return the state of the object as a string. The matching \_load method is a class method that accepts the string returned by \_dump and returns an object.

    class Season
      # We want to allow Season objects to be marshaled, but we don't
      # want new instances to be created when they are unmarshaled.
      def _dump(limit) # Custom marshaling method
        @n.to_s # Return index as a string
      end

      def self._load(s) # Custom unmarshaling method
        INSTANCES[Integer(s)] # Return an existing instance
      end
    end

- - -

Properly implementing a **singleton** requires a number of the tricks shown earlier. The new and allocate methods must be made private, dup and clone must be prevented from making copies, and so on.

just `require 'singleton'` and then include Singleton into your class. This defines a class method named **instance**.
