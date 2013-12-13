## Making Method Calls Simpler

One of the most valuable conventions I’ve used over the years is**to clearly separate methods that change state (modifiers) from those that query state (queries).**

* Rename Method
* Add Parameter
* Remove Parameter
* Seperate Query from Modifier
* Parameterize Method
* Replace Parameter with Explicit Methods
* Preserve Whole Object
* Replace Parameter with Method
* Introduce Parameter Object
* Remove Setting Method
* Hide Method
* Replace Constructor with Factory Method
* Replace Error Code with Exception
* Replace Expression with Test
* Introduce Gateway
* Introduce Expression Builder

- - -

### Rename Method

Remember your code is for a human first and a computer second. Humans need good names.

### Add Parameter

### Remove Parameter

A param- eter indicates information that is needed; different values make a difference. Your caller has to worry about what values to pass.

Check to see whether this method signature is implemented by a super- class or subclass. Check to see whether the subclass or superclass uses the parameter. If it does, don’t do this refactoring.

### Seperate Query from Modifier

Create two methods, one for the query and one for the modification.

A good rule to follow is to say that any method that returns a value should not have observable side effects.

### Parameterize Method

### Replace Parameter with Explicit Methods

Create a separate method for each value of the parameter.

> NOTE:

> Parameterize Method，是找到基于相同 value 的不同操作，并归纳为函数。

> Replace Parameter with Explicit Methods，则是当参数值变化不多时（v in [a, b, c]），可直接分别提供 a, b, c 三个方法进行处理。
>
> 这样显式将参数值写进方法名可以提供更可读易用的接口。
>
> if :hourly == @time_unit
>   dp_query_hourly
> els if :daily == @time_unit
>   dp_query_daily
> ...

`Switch.turn_on` is a lot clearer than `Switch.set_state(true)`

With the parameter, any programmer using the method needs not only to look at the methods on the class but also to determine a valid parameter value. The latter is often poorly documented.

### Preserve Whole Object

**Passing in the required object causes a dependency between the required object and the called object.**
If this is going to mess up your dependency structure, don’t use Preserve Whole Object.

### Replace Parameter with Method

An object invokes a method, then passes the result as a parameter for a method. The receiver can also invoke this method.

### Introduce Parameter Object

You get a deeper benefit, however, because once you have clumped together the parameters, you soon see behavior that you can also move into the new class.

### Remove Setting Method

A field should be set at creation time and never altered.

If the change is simple (as here), I can make the change in the constructor. If the change is complex or I need to call it from separate methods, I need to provide a method. In that case I need to name the method to make its intention clear:

```
class Account
  def initialize(id)
    initialize_id(id)
  end
  def initialize_id(value)
    @id = "ZZ#{value}"
  end
end
```

### Hide Method

Ideally a tool should check all methods to see whether they can be hidden. If it doesn’t, you should make this check at regular intervals.

A particularly common case is hiding, getting, and setting methods as you work up a richer interface that provides more behavior.

Use a lint-style tool, do manual checks every so often, and check when you remove a call to a method in another class.

### Replace Constructor with Factory Method

You want to do more than simple construction when you create an object.

The most obvious motivation for Replace Constructor with Factory Method is when you have conditional logic to determine the kind of object to create. If you need to do this conditional logic in more than one place, it’s time for a Factory Method.

### Replace Error Code with Exception

Should the caller check for the error condition before calling the method, or should it rescue the exception? I look to the likelihood of the error condition occurring to help me decide.

+ If the error is likely to occur in normal processing, then I would make the caller check the condition before calling.
+ If the error is not likely to occur, then I would rescue the exception.

### Replace Exception with Test

Change the caller to make the test first.

```
def execute(command)
  # command.prepare rescue nil
  command.prepare if command.respond_to? :prepare
  command.execute
end
```

### Introduce Gateway

Introduce a Gateway that encapsulates access to an external system or resource.

### Introduce Expression Builder

An Expression Builder provides a fluent interface as a separate layer on top of the regular API.

![img](baidu.com)
