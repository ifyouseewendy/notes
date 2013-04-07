###\# Foreword

A **method** is a named block of parameterized code associated with one or more objects.

> Many languages distinguish between **functions**, which have no associated object, and
> **methods**, which are invoked on a receiver object.

**Blocks**, are executable chunks of code and may have parameters. Unlike
methods, blocks do not have names, and they can only be invoked indirectly through
an iterator method.

Blocks, like methods, are not objects that Ruby can manipulate. But it’s possible to
create an object that represents a block, and this is actually done with some frequency
in Ruby programs.

A **Proc** object represents a block. Like a Method object, we can execute the code of a block through the Proc that represents it. There are two varieties of Proc objects, called **procs** and **lambdas**, which have slightly different behavior. Both procs and lambdas are functions rather than methods invoked on an object.

An important feature of procs and lambdas is that they are closures: they retain access to the local variables that were in scope when they were defined, even when the proc or lambda is invoked from a different scope.

- - -

###\# \* splat operator

+ in method definition, it packs an array
+ in method invocation, it unpacks an array

- - -

###\# Creating Procs

1. method

        def makeproc(&p)
          p
        end

        adder = makeproc { |x,y| x+y }
        adder.call(2,2) # => 4


2. `Proc.new { |x,y| x+y }`

3. lambda

  + `Kernel.lambda`
  + lambda literals

        succ = ->(x) { x+1 }
        succ.call(2)    # => 3

        # This lambda takes 2 args and declares 3 local vars
        f = ->x,y; i,j,k { ... }

        # with argument defaults
        z = ->x,y,factor=2 { [x*factor, y*factor] }

        # minimal lambda
        ->{}


4. `Kernel.proc` # synonym for lambda in 1.8, for Proc.new in 1.9

- - -

###\# Arity of a Proc

    lambda{||}.arity # => 0. No arguments expected
    lambda{|x| x}.arity # => 1. One argument expected
    lambda{|x,y| x+y}.arity # => 2. Two arguments expected

    lambda {|*args|}.arity # => -1. ~-1 = -(-1)-1 = 0 arguments required
    lambda {|first, *rest|}.arity # => -2. ~-2 = -(-2)-1 = 1 argument required

    puts lambda {}.arity # –1 in Ruby 1.8; 0 in Ruby 1.

- - -

###\# Proc Equality

The == method only returns true if one Proc is a clone or duplicate of the other:

    lambda {|x| x*x } == lambda {|x| x*x } # => false

    p = lambda {|x| x*x }
    q = p.dup
    p == q # => true: the two procs are equal
    p.object_id == q.object_id # => false: they are not the same object

- - -

###\# Difference between Lambdas and Procs

1. **return**

  + A proc is like a block, so if you call a proc that executes a return statement, it attempts to return from the method that encloses the block that was converted to the proc.

    By converting a block into an object, we are able to pass that object around and use it
    “out of context.” If we do this, we run the risk of returning from a method that has
    already returned, as was the case here. When this happens, Ruby raises a
    LocalJumpError.

  + lambdas work more like methods than blocks. A return statement in a lambda, therefore, returns from the lambda itself, not from the method that surrounds the creation site of the lambda

  + other control-flow statements

    - **redo** also works the same in procs and lambdas: it transfers control back to the beginning of the proc or lambda.
    - **retry** is never allowed in procs or lambdas: using it always results in a LocalJumpError.

2\. **Argument** passing to procs and lambdas

    p = Proc.new {|x,y| print x,y }
    p.call(1) # x,y=1: nil used for missing rvalue: Prints 1nil
    p.call(1,2) # x,y=1,2: 2 lvalues, 2 rvalues: Prints 12
    p.call(1,2,3) # x,y=1,2,3: extra rvalue discarded: Prints 12
    p.call([1,2]) # x,y=[1,2]: array automatically unpacked: Prints 12

    l = lambda {|x,y| print x,y }
    l.call(1,2) # This works
    l.call(1) # Wrong number of arguments
    l.call(1,2,3) # Wrong number of arguments
    l.call([1,2]) # Wrong number of arguments
    l.call(*[1,2]) # Works: explicit splat to unpack the array

- - -

###\# Closures

In Ruby, procs and lambdas are closures.

The term **"closure"** comes from the early days of computer science: **it refers to an object that is both an invocable function and a variable binding for that function**.

When you create a proc or a lambda, the resulting Proc object holds not just the executable block but also bindings for all the variables used by the block.

It is important to understand that a closure does not just retain the value of the variables it refers to -- **it retains the actual variables and extends their lifetime**.

    # Return a pair of lambdas that share access to a local variable.
    def accessor_pair(initialValue=nil)
      value = initialValue # A local variable shared by the returned lambdas.
      getter = lambda { value } # Return value of local variable.
      setter = lambda {|x| value = x } # Change value of local variable.
      return getter,setter # Return pair of lambdas to caller.
    end

    getX, setX = accessor_pair(0) # Create accessor lambdas for initial value 0.
    puts getX[] # Prints 0. Note square brackets instead of call.
    setX[10] # Change the value through one closure.
    puts getX[] # Prints 10. The change is visible through the other. }

The Proc class defines a method named binding. Calling this method on a proc or lambda returns a Binding object that represents the bindings in effect for that closure.

The use of a Binding object and the eval method gives us a back door through which we can manipulate the behavior of a closure.

    # Return a lambda that retains or "closes over" the argument n
    def multiplier(n)
      lambda {|data| data.collect{|x| x*n } }
    end
    doubler = multiplier(2) # Get a lambda that knows how to double
    puts doubler.call([1,2,3]) # Prints 2,4,6

    eval("n=3", doubler.binding) # Or doubler.binding.eval("n=3") in Ruby 1.9
    puts doubler.call([1,2,3]) # Now this prints 3,6,9!

    # shortcut
    eval("n=3", doubler)
