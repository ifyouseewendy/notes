== Listing and Testing for Methods

for object

    o = "a string"
    o.methods # => [ names of all public methods ]
    o.public_methods # => the same thing
    o.public_methods(false) # Exclude inherited methods
    o.protected_methods # => []: there aren't any
    o.private_methods # => array of all private methods
    o.private_methods(false) # Exclude inherited private methods
    def o.single; 1; end # Define a singleton method
    o.singleton_methods # => ["single"] (or [:single] in 1.9) ]

for class

    String.instance_methods == "s".public_methods # => true
    String.instance_methods(false) == "s".public_methods(false) # => true
    String.public_instance_methods == String.instance_methods # => true
    String.protected_instance_methods # => []
    String.private_instance_methods(false) # => ["initialize_copy", "initialize"]

    # class methods
    Math.singleton_methods # => ["acos", "log10", "atan2", ... ]

    # for testing
    String.public_method_defined? :reverse # => true
    String.protected_method_defined? :reverse # => false
    String.private_method_defined? :initialize # => true
    String.method_defined? :upcase! # => true

To query a specific named method, call method on any object or instance_method on any module.

- - -

== Obtaining Method Objects

    "s".method(:reverse) # => Method object
    String.instance_method(:reverse) # => UnboundMethod object

- - -

== Invoking Methods

  "hello".send :puts, "world" # prints "world"
  "hello".public_send :puts, "world" # raises NoMethodError

- - -

== Defining, Undefining, and Aliasing Methods

It is important to understand that **define_method is a private method of Module**. You must be inside the class or module you want to use it on in order to call it.

    # Add an instance method named m to class c with body b
    def add_method(c, m, &b)
      c.class_eval {
        define_method(m, &b)
      }
    end

    add_method(String, :greet) { "Hello, " + self }

    "world".greet # => "Hello, world"

To define a class method (or any singleton method) with define_method, invoke it on the eigenclass:

    def add_class_method(c, m, &b)
      eigenclass = class << c; self; end
      eigenclass.class_eval {
        define_method(m, &b)
      }
    end

    add_class_method(String, :greet) {|name| "Hello, " + name }

    String.greet("world") # => "Hello, world"

In Ruby1.9

    String.define_singleton_method(:greet) {|name| "Hello, " + name }

Like define_method, **alias_method** is a private method of Module.

**undef** to undefine a method works only if you can express the name of a method as a hardcoded identifier in your
program. If you need to dynamically delete a method whose name has been computed
by your program, you have two choices: **remove_method** or **undef_method**. Both are private methods of Module.

- **remove_method** removes the definition of the method from the current class. If there is a version defined by a superclass, that version will now be inherited. 
- **undef_method** is more severe; it prevents any invocation of the specified method through an instance of the class, even if there is an inherited version of that method.

If you define a class and want to prevent any dynamic alterations to it, simply invoke the **freeze** method of the class. Once frozen, a class cannot be altered.

- - -

== Handling Undefined Methods

The default implementation of **method_missing**, in the **Kernel** module, simply raises a
**NoMethodError**. This exception, if uncaught, causes the program to exit with an error
message, which is what you would normally expect to happen when you try to invoke
a method that does not exist.

  class Hash
    # Allow hash values to be queried and set as if they were attributes.
    # We simulate attribute getters and setters for any key.
    def method_missing(key, *args)
      text = key.to_s

      if text
        self[text.chop.to_sym] = args[0] # Strip = from key
      else # Otherwise...
        self[key] # ...just return the key value
      end
    end
  end

  h = {} # Create an empty hash object
  h.one = 1 # Same as h[:one] = 1
  puts h.one # Prints 1. Same as puts h[:one]

== Setting Method Visibility

    String.class_eval { private :reverse }
    "hello".reverse # NoMethodError: private method 'reverse'

    # Make all Math methods private
    # Now we have to include Math in order to invoke its methods
    Math.private_class_method *Math.singleton_methods
