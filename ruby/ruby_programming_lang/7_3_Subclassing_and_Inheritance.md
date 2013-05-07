If you do not specify a superclass when you define a class, then your class implicitly extends **Object**. A class may have any number of subclasses, and every class has a single superclass except **Object**, which has none.

- - -

When invoking a **class method** with an explicit receiver, you should avoid relying on inheritance—always invoke the class method through the class that defines it.

- - -

All Ruby objects have a set of instance variables. These are not defined by the object’s class—they are simply created when a value is assigned to them. Because **instance variables are not defined by a class, they are unrelated to subclassing and the inheritance mechanism.**

The reason that they sometimes appear to be inherited is that instance variables are created by the methods that first assign values to them, and those methods are often inherited or chained.

Confusing.

> There is an important corollary. Because instance variables have nothing to do with
> inheritance, it follows that an instance variable used by a subclass cannot “shadow” an
> instance variable in the superclass. If a subclass uses an instance variable with the same
> name as a variable used by one of its ancestors, it will overwrite the value of its ancestor’s
> variable. This can be done intentionally, to alter the behavior of the ancestor, or it can
> be done inadvertently. In the latter case, it is almost certain to cause bugs. As with the
> inheritance of private methods described earlier, this is another reason why it is only
> safe to extend Ruby classes when you are familiar with (and in control of) the
> implementation of the superclass.

- - -

The important difference between **constants and methods** is that constants are looked up in the lexical scope of the place they are used before they are looked up in the inheritance hierarchy.
