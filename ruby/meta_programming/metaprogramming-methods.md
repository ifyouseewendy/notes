## Methods

### Dynamic Dispatch

Why would you use `send` instead of the plain old dot notation? Because with `send`, the name of the method that you want to call becomes just a regular argument. You can wait literally until the very last moment to decide which method to call, while the code is running. This technique is called Dynamic Dispatch.

**An example of Dynamic Dispatch**

	# gems/pry-0.9.12.2/lib/pry/pry_instance.rb
	def refresh(options={})
	  defaults = {}

			


		send("#{key}=", value) if respond_to?("#{key}=")

	end

**What's the concern about `send`?**

You can call any method with `send`, including private methods.

You can use `public_send` instead. It’s like send, but it makes a point of respecting the receiver’s privacy.

### Dynamic Method

There is one important reason to use `Module#define_method`(***private***) over the more familiar def keyword: `define_method` allows you to decide the name of the defined method at runtime.

### Ghost Method

`BasicObject#method_missing` (***private***)

Ghost Methods are usually icing on the cake, but some objects actually rely almost exclusively on them. They collect method calls through `method_missing` and forward them to the wrapped object.

**How can `respond_to?` missing methods?**

`respond_to?` calls a method named `respond_to_missing?`, that is supposed to return true if a method is a Ghost Method. To prevent `respond_to?` from lying, override `respond_to_missing?` every time you override method_missing:

	class Computer
	  # ...


**What about the constant missing?**

 `Module#const_missing`(***public***)

**What's the concern about `method_missing`?**


**How to solve it? Blank Slate!**

Remove methods from an object to turn them into Ghost Methods.
 Inheriting from `BasicObject` is the quicker way to define a Blank Slate in Ruby.

+ Inheriting from `Object` by default, and remove method inherited.


**What's the difference between `undef_method` and `remove_method`?**

+ The drastic `undef_method` removes any method, including the inherited ones. 
+ The kinder `remove_method` removes the method from the receiver, but it leaves inherited methods alone.

**What's the boiling down facts between Ghost Method and really methods?**

Ghost Method are just a way to intercept method calls. Because of this fact, they behave different than actual methods.

**What's the choice between `define_method` and `method_missing`?**

 When you have a large number of method calls.
 When you don’t know what method calls you might need at runtime.

