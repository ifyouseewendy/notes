== listing variables

The **global_variables, instance_variables, class_variables, and constants** methods
return arrays of strings in Ruby 1.8 and arrays of symbols in Ruby 1.9. The
**local_variables** method returns an array of strings in both versions of the language.

- - -

== querying, setting, and testing variables

    x = 1
    varname = "x"
    eval(varname) # => 1
    eval("varname = '$g'") # Set varname to "$g"
    eval("#{varname} = x") # Set $g to 1
    eval(varname) # => 1

Note that **eval** evaluates its code in a **temporary scope**. _eval can alter the value of
instance variables that already exist. But any new instance variables it defines are local
to the invocation of eval and cease to exist when it returns._ (It is as if the evaluated
code is run in the body of a block—variables local to a block do not exist outside the block.)

    o = Object.new
    o.instance_variable_set(:@x, 0) # Note required @ prefix
    o.instance_variable_get(:@x) # => 0
    o.instance_variable_defined?(:@x) # => true

    Object.class_variable_set(:@@x, 1) # Private in Ruby 1.8
    Object.class_variable_get(:@@x) # Private in Ruby 1.8
    Object.class_variable_defined?(:@@x) # => true; Ruby 1.9 and later

    Math.const_set(:EPI, Math::E*Math::PI)
    Math.const_get(:EPI) # => 8.53973422267357
    Math.const_defined? :EPI # => true


The methods for querying and setting class variables are **private** in Ruby 1.8.

In Ruby1.9, you can pass false as the second argument to const_get and
const_defined? to specify that these methods should only look at the current class or
module and should not consider inherited constants.

    o.instance_eval { remove_instance_variable :@x }
    String.class_eval { remove_class_variable(:@@x) }
    Math.send :remove_const, :EPI # Use send to invoke private method


