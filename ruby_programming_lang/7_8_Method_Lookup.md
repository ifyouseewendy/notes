**Method Name Resolution**
- - -

    message = "hello"
    message.world

1. Check the **eigenclass** for singleton methods. There aren’t any in this case.
2. Check the **String** class. There is no instance method named world.
3. Check the **Comparable** and **Enumerable** modules of the **String** class for an instance method named world. Neither module defines such a method. ( **the most recently included module is searched first** )
4. Check the **superclass** of String, which is **Object**. The Object class does not define a method named world, either.
5. Check the **Kernel** module included by Object. The world method is not found here either, so we now switch to looking for a method named method_missing.
6. Look for **method_missing** in each of the spots above (the eigenclass of the String object, the String class, the Comparable and Enumerable modules, the Object class, and the Kernel module). The first definition of method_missing we find is in the Kernel module, so this is the method we invoke. What it does is raise an exception:  

        NoMethodError: undefined method 'world' for "hello":String


P.S.

    def Integer.parse(text)
      text.to_i
    end

    n = Fixnum.parse('1')

**The eigenclasses of class objects are also special: they have superclasses.**

So when looking for a class method of **Fixnum**, Ruby first checks the **singleton methods** of **Fixnum**, **Integer**, **Numeric**, and **Object**, and then checks the instance methods of **Class**, **Module**, **Object**, and **Kernel**.



