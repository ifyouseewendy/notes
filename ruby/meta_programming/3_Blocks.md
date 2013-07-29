**绑定(binding)**：
当代码运行时，它需要一个环境：局部变量，实例变量，self……既然这些东西是绑定在对象上的名字，就简称为绑定。

**闭包(closure)**：
+ 块
+ 当创建块时会获取到局部绑定，然后把块连同它自己的绑定传给一个方法
+ 块可以获得局部绑定，并一直带着它们
+ 块会在定义时获取周围的绑定，你可以在块的内部定义额外的绑定，但是这些绑定在块结束时就会消失：

```ruby
def my_method
  yield
end

top_level_variable = 1
my_method do
  top_level_variable += 1
  local_to_block = 1
end

top_level_variable  # => 2
local_to_block      # => error
```

**作用域(scope)**

在作用域中，你会看到到处都是绑定。

在Java和C#中，有‘内部作用域(inner scope)’的概念。在内部作用域中可以看到‘外部作用域(outer scope)’中的变量。但Ruby中没有这种嵌套式的作用域，它的作用域是截然分开的：一旦进入一个新的作用域，原先的绑定就会被替换为一组新的绑定。

只要程序切换了作用域，一些绑定就会被全新的绑定所替代。

程序会在三个地方关闭一个作用域，同事打开一个新的作用域：
+ `class`
+ `module`
+ `def`

每一个关键字都充当了一个**作用域门(scope gate)**

*怎样让绑定穿越一个作用域门？*

使用**扁平作用域(flat scope)**，即可共享作用域：
+ `Class.new => class`
+ `Module.new => module`
+ `Module#define_method => def`

可以把传递给`instance_eval`方法的块称为一个**上下文探针(context probe)**
`instance_eval`方法跟`instance_eval`相似，但它允许对块传入参数：
```ruby
class C
  def initialize
    @x, @y = 1, 2
  end
end

C.new.instance_eval(3) {|arg| (@x + @y) * arg }  # => 9
```

**可调用对象**

```ruby
inc = Proc.new {|x| x + 1 }
inc.call(2)  # => 3
```
这种技术成为**延迟执行(deferred Evaluation)**

**&操作符**

块就像是方法的额外的匿名参数。绝大多数情况下，在方法中可以通过`yield`语句直接运行一个块。但在下面两种情况中，`yield`将力不从心：
+ 想把这个块传递给另外一个方法
+ 想把这个块转换为一个Proc

&操作符的真正含义是：这是一个`Proc`对象，我想把它当成一个块来使用。

```ruby
def my_method(&the_proc)
  the_proc
end

p = my_method {|name| "Hello, #{name}!"}
puts p.class
puts p.call("Bill")

def my_method(greeting)
  puts "#{greeting}, #{yield}"
end

my_proc = Proc.new { 'Bill' }
my_method("Hello", &my_proc)
```

**lambda & proc**

+ `return`

  - 在`lambda`中，`return`仅表示从`lambda`中返回
  - 在`proc`中，`return`不是从`proc`返回，而是从定义`proc`的作用域返回

```ruby
def another_double
  p = Proc.new { return 10 }
  result = p.call
  return result * 2  # => unreachable code!
end
```
+ arity

  - 调用`lambda`参数数量不对时，会抛出`ArgumentError`
  - `proc`则会将参数调整为自己期望的参数形式






