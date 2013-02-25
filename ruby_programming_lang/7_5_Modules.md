**Modules** are used as namespaces and as mixins. Unlike a class, a module cannot be instantiated, and it cannot be subclassed.

- - -

Modules as Namespaces

If your implementation of a class requires a helper class, a proxy class, or some other class that is not part of a public API, you may want to consider nesting that internal class within the class that uses it. This keeps the namespace tidy but does not actually make the nested class private in any way.

- - -

Modules as Mixins

- **Enumerable** defines useful iterators that are implemented in terms of an **each** iterator.
- **Comparable** defines comparison operators in terms of the general-purpose comparator `<=>`.

**include** is a private instance method of Module, implicitly invoked on **self**.

Although every class is a module, the include method does not allow a class to be included within another class. The arguments to include must be modules declared with module, not classes.

The normal way to mix in a module is with the **Module#include** method. Another way is with **Object#extend**. This method makes the instance methods of the specified module or modules into singleton methods of the receiver object.

    countdown = Object.new # A plain old object
    def countdown.each # The each iterator as a singleton method
      yield 3
      yield 2
      yield 1
    end
    countdown.extend(Enumerable) # Now the object has all Enumerable methods
    print countdown.sort # Prints "[1, 2, 3]"

- - -

- The inclusion of a module affects the type-checking method **is_a?** and the switchequality operator **===**.
- Note that **instanceof?** only checks the class of its receiver, not superclasses or modules.

        "text".is_a? Comparable # => true
        "text".instance_of? Comparable # => false

- - -

It is possible to define modules that define a namespace but still allow their methods
to be mixed in. The Math module works like this:

    Math.sin(0)     # => 0.0: Math is a namespace
    include 'Math'  # The Math namespace can be included
    sin(0)          # => 0.0: Now we have easy access to the functions

**module_function** is a private instance method of Module, much like the public, protected, and private methods.

any instance methods subsequently defined by module\_functions: they will become **public class methods** and **private instance methods**.

- - -

When **defining a module function**, you should **avoid using self**, because the value of self will depend on how it is invoked.

