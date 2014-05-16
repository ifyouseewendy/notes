### the Callables

> Package code, and call it later

+ **block**, evaluated in the scope which they're defined.
+ **proc**, which is basically a block turned object, and evaluated in the scope which they're defined.
+ **lambda**, which is a slight variation on a proc.
+ **method**, bound to an object, which are evaluated in that object’s scope. They can also be unbound from their scope and rebound to another object or class.

 **block** is not an object, while **proc** and **lambda** are Proc objects, and **method** is [in question](http://stackoverflow.com/questions/2602340/methods-in-ruby-objects-or-not).

### Blocks

The main point about blocks is that they are all inclusive and come ready to run. They contain both the **code** and **a set of bindings**.

**When you define the block, it simply grabs the bindings that are there at that moment**, and then it carries those bindings along when you pass the block into a method.

	def my_method



**What if I define additional bindings inside a block?**

They disappear after the block ends.

**What's the meaning of "a block is a closure"?**

a block is a closure, this means a block captures the local bindings and carries them along with it.

**scope**

You can see bindings all over the scope. 

`class`, `module`, and `def`, respectively. Each of these keywords acts like a **Scope Gate**.

**A subtle difference between `class`, `module` and `def`**

The code in a `class` or `module` definition is executed immediately. Conversely, the code in a method definition is executed later, when you eventually call the method.

**Whenever the program changes scope, some bindings are replaced by a new set of bindings. RIGHT?**

For `local_varialbes`, that's right, but `instance_variables`, `class_variables` and `global_variables` can go through the Scope Gate. 

**What's the difference between Global Variables and Top-Level Instance Variables?**

when it comes to global variables, use them sparingly, if ever.

You can access a top-level instance variable whenever `main` takes the role of self. When any other object is `self`, the top-level instance variable is out of scope.

**How to across the Scope Gate, and Why?**

+ Use Flat Scope
+ Use Shared Scope
+ Use Context Probe (`BasicObject#instance_eval`)

to mix code and bindings at will.

**What is Flat Scope?**

“flattening the scope,” meaning that the two scopes share variables as if the scopes were squeezed together. For short, you can call this spell a Flat Scope.

Use `Class.new`, `Module.new` and `define_method`.

**What is Shared Scope?**

	# use `def` to do seperate
	def define_methods
	  shared = 0

		shared += x




**What is Context Probe?**

`instance_eval` has a slightly more flexible twin brother named `instance_exec`, that allows you to pass arguments to the block.

	class C
	end
	
	  end







*Shared Scope* is used in definition, to make variables(bindings) shared between methods, while *Clean Room* is used to run code, to help reduce the modifications on shared variables(like instance variables). 

        setups << block

        events.each do |event|

      env = Object.new
      each_setup do |setup|
    end
**When is `yield` not enough to use?**

+ You want to pass the block to another method (or even another block).
+ You want to convert the block to a `Proc`.






    	proc { |x| x + 1 }
  	  lambda { |x| x + 1 }
        -> x { x + 1 } # stabby lambda

**Ways to create Procs implicitly**

use `&` to convert block into a proc:

	def make_proc(&p)
	  p
	end
	
	make_proc {|x| x + 1 }
        

	p[41]
	p === 41
	p.(41)
	
**Use `&` to convert a block to Proc**

	def my_method(&the_proc)
	  the_proc

**Use `&` to convert a Proc to block**

	
**What's a lambda?**


 `return`


 **arity**



**Conversions between methods and procs**

 Use `Method#to_proc` to convert a method into proc.
 Use `define_method` to convert a proc into method.





 use `Method#unbind`

	  def foo; end
	  unbound = method(:foo).unbind
	  unbound.class 	# => UnboundMethod
 use `Module#instance_method`

	  unbound.class 	# => UnboundMethod
	 
  *Note:* `instance_methods` is totally different, it's like `methods`, just return an array of symbols.
  
**usage**

+ bind the UnboundMethod to an object with `UnboundMethod#bind`. UnboundMethods that come from a class can only be bound to objects of the same class (or a subclass), while UnboundMethods that come from a module have no such limitation from Ruby 2.0 onwards.
+ use an UnboundMethod to define a brand new method by passing it to `Module#define_method`.

	  String.class_eval do


**example**

In ActiveSupport, the 'autoloading' system includes a `Loadable` module, which redefines the standard `Kernel#load`. If a class includes `Loadable`, then `Loadable#load` gets lower then `Kernel#load` on its chain of ancestors.

And what if you want to stop using `Loadable#load` and go back to the plain vanilla `Kernel#load`?

	# gems/activesupport-4.0.2/lib/active_support/dependencies.rb
	module Loadable
	  def exclude_from(base)
	    base.class_eval { define_method :load, Kernel.instance_method(:load) }
	  end
	end