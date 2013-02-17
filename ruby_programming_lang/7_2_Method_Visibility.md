Methods are normally **public** unless they are explicitly declared to be private or protected.  

- one **exception** is the initialize method, which is always implicitly private.  
- another **exception** is any “global” method declared outside of a class definition—those methods are defined as private instance methods of Object.

- - -

A **private** method is internal to the implementation of a class, and it can only be called by other instance methods of the class (or, as we’ll see later, its subclasses).  

Private methods are implicitly invoked on **self**, and may not be explicitly invoked on an object.

If **m** is a private method, then you must invoke it in functional style as **m**. You cannot write **o.m** or even **self.m**.

- - -

> A **protected** method is like a private method in that it can only be invoked from within
> the implementation of a class or its subclasses. It differs from a private method in that
> it may be explicitly invoked on any instance of the class, and it is not restricted to
> implicit invocation on self. A protected method can be used, for example, to define
> an accessor that allows instances of a class to share internal state with each other, but
> does not allow users of the class to access that state.

In my understanding, a **protected** method is like private that cannot be called by instance explicitly, but differs that it can be called on **self**. SO it can be called by instance in class definition, but cannot be called by user code.

- - -

An example.

    class Hobbit
      def initialize(name, rooms, has_ring)
        @name, @rooms, @has_ring = name, rooms, has_ring
      end

      def name
        @name
      end

      def name_of(hobbit)
        hobbit.name
      end

      def rooms_of(hobbit)
        hobbit.rooms
      end

      def hobbit_has_ring?(hobbit)
        hobbit.has_ring?
      end

      protected

      def rooms
        @rooms
      end

      private

      def has_ring?
        @has_ring
      end
    end

Test

    irb(main):001:0> require 'hobbit.rb'
    => true
    irb(main):002:0> frodo = Hobbit.new('Frodo', 3, true)
    => #<Hobbit:0x10038b5c0 @rooms=3, @name="Frodo", @has_ring=true>
    irb(main):003:0> samwise = Hobbit.new('Samwise', 2, false)
    => #<Hobbit:0x1003769e0 @rooms=2, @name="samwise", @has_ring=false>

    # Public Methods
    irb(main):004:0> frodo.name
    => "Frodo"
    irb(main):005:0> samwise.name
    => "Samwise"

    # Protected Methods
    irb(main):006:0> frodo.rooms
    NoMethodError: protected method `rooms' called for #<Hobbit:0x10034a4a8 @rooms=3, @name="Frodo", @has_ring=true>
    irb(main):007:0> frodo.rooms_of(frodo)
    => 3
    irb(main):008:0> frodo.rooms_of(samwise)
    => 2

    # Private Methods
    irb(main):013:0> frodo.has_ring?
    NoMethodError: private method 'has_ring?' called for #<Hobbit:0x10034a4a8 @rooms=3, @name="Frodo", @has_ring=true>
    irb(main):014:0> frodo.hobbit_has_ring?(frodo)
    NoMethodError: private method 'has_ring?' called for #<Hobbit:0x10034a4a8 @rooms=3, @name="Frodo", @has_ring=true>
    irb(main):015:0> frodo.hobbit_has_ring?(samwise)
    NoMethodError: private method 'has_ring?' called for #<Hobbit:0x100374c80 @rooms=2, @name="Samwise", @has_ring=false>

- - -

Remember that public, private, and protected apply only to methods in Ruby.

Instance and class variables are encapsulated and effectively private, and constants are effectively public. 

There is no way to make an instance variable accessible from outside a class (except by defining an accessor method, of course). And there is no way to define a constant that is inaccessible to outside use.

Occasionally, it is useful to specify that a class method should be private. If your class defines factory methods, for example, you might want to make the new method private. To do this, use the `private_class_method` method, specifying one or more method names as symbols:

    private_class_method :new

You can make a private class method public again with `public_class_method`.
