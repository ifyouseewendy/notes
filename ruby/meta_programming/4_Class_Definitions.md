+ 在Java和C#等语言中，定义类就像和编译器签订合同，直到创建了该类的一个对象时，然后调用该对象的方法才会有实际工作
+ 在Ruby中，当使用`class`关键字时，并非是在指定对象未来的行为方式，实际上是在运行代码

**当前对象 & 当前类**

+ 当前对象`self`是调用方法时的默认接收者
+ 当前类是定义方法时的默认所在地

不管处在Ruby程序的哪个位置，总是存在一个当前对象：`self`。尽管可以用`self`获得当前对象，但Ruby并没有相应的方式获得当前类的引用。

追踪当前类可通过：每当通过`class`或`module`打开一个类或模块时，这个类就成为当前类。

当前类的特殊情况：

```ruby
class MyClass
  def method_one
    # 当前类的角色由self的类来充当 - MyClass
    def method_two; 'Hello?'; end
  end
  
  def self.method_three
    def method_four; 'Hello?'; end
  end
end

obj = MyClass.new
obj.method_one
obj.method_two  # => 'Hello?'
obj.class.method_three
obj.method_four  # => 'Hello?'
```

+ `Object#instance_eval`方法仅仅会修改`self`
+ `Module#class_eval`方法同时会修改`self`和当前类。通过修改当前类，`class_eval`实际上是重新打开了当前类，就像`class`关键字所做的一样

**类实例变量**

```ruby
class MyClass
  @my_var = 1

  def self.read; @my_var; end
end
```

+ 类变量，后代继承并共享类变量导致行为诡异
+ 类实例变量，在后代继承时重新生成(nil)

**Duck Typing**

像Ruby这样的动态语言，对象的类型并不严格与它的类相关，它的‘类型’只是一组它能相应的方法

**类宏(class macros)**

`Module#attr_accessor`，模块中也可使用`attr_accessor`，`include`包含用。

**Eigenclass**

eigenclass是一个对象的单件方法的存货之所。每个eigenclass只有一个实例，且不可被继承。

关于超类：
+ 对象的eigenclass的超类是这个对象的类
+ 类的eigenclass的超类是这个类的超类的eigenclass

类属性存活在该类的eigenclass中，对象的实例变量（实例方法）存放在对象的eigenclass中，类的实例变量（实例方法）存放在类的eigenclass中

eigenclass用来存放对象的实例变量（实例方法）和单件方法

当类包含模块时，它获得的是该模块的实例方法 - 而不是类方法。类方法存在于模块的eigenclass中，依然无法触碰
+ `Module#include`用来在类中包含模块的实例方法
+ `Object#extend`用来在对象的eigenclass中包含模块的实例方法

**alias & alias_method**

+ **alias**是一个关键字，而非一个方法。这就是为什么两个方法名之间没有逗号

```ruby
alias :new_name :old_name
```

+ `Module#alias_method`功能与alias相同

```ruby
  alias_method :new_name, :old_name
```

**环绕别名(around alias)**

1. 给方法定义一个别名
2. 重定义这个方法
3. 在新的方法中调用老的方法

可以使用环绕别名进行异常处理，并添加新的逻辑

```ruby
module Kernel
  alias gem_original_require require
  
  def require(path)
    gem_original_require path
  rescue LoadError => load_error
    if load_error.message =~ /#{Regexp.escape path}\z/ and
      spec = Gem.searcher.find(path) then
      Gem.activate(spec.name, "= #{spec.version}")
      gem_original_require path
    else
      load_error
    end
  end
end
```

*弊端*：
1. monkey patch
2. 你永远不该把一个环绕别名加载两次（最初的方法将丢失）
