由于`class`关键字既可以用来创建类，也可以打开类，所以`class`关键字更像是一个作用域操作符，而不是类型声明语句。

Ruby中对象和它的实例变量没有关系，当给实例变量赋值时，它们就生成了。因此对一个类可以创建具有不同实例变量的对象。

一个对象，仅仅包含它的实例变量以及一个对自身类的引用。（准确说还包括一个唯一标识符object\_id，和一组诸如tainted, frozen这样的状态）

一个对象的实例变量存在鱼对象本身，而一个对象的方法存在于对象自身的类。这就是为什么同一个类的对象共享同样的方法，但不共享实例变量的原因。

一个类只不过是一个增强的`Module`，增加了三个方法 -- `new(), allocate(), superclass()`

![img](img_1.png)

通常，希望在别处被`include`或者作为命名空间时，应该选择使用**模块**，当希望被实例化或继承时，应该选择使用类。

`load`方法的第二个参数可以用来强制其常量仅在自身范围内有效： `load('file.rb' true)`。
Ruby会创建一个匿名模块，使用它来作命名空间容纳加载进的所有常量（包括可能冲突的类名），加载完成后，该模块会被销毁。

`load`方法用来执行代码，`require`则是用来导入类库，所以require方法没有第二个可选参数。

当调用方法时，Ruby会做两件事：

+ 查找方法（接收者，祖先链）
+ 执行方法（self)

Ruby按照'向右一步，再向上'的规则找到该方法，然后以`self`作为接收者执行该方法。

`MySubclass.ancestors # => [MySubclass, MyClass, Object, Kernel, BasicObject]`
当一个类（或者是另一个模块）中包含(include)一个模块时，Ruby创建了一个封装该模块的匿名类，并把这个类插入到祖先链中，位置正好包含在它的类上方。

```ruby
class Book
  include Module1
  include Module2

  ...
end

Book.ancestors # => [Book, Module2, Module1, Object, Kernel, BasicObject]
```

当开始运行Ruby程序时，Ruby解释器会创建一个名为`main`的对象作为当前对象，有时也被称为**顶级上下文(top level context)**。

私有方法服从一个简单的规则：不能明确指定一个接收者来调用一个私有方法。即每一个私有方法都只能调用于一个隐含的接收者`self`上。

