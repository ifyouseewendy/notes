**动态派发(dynamic dispath)**： `send`

**动态方法(dynamic method)**： `define_method`

**动态代理(dynamic proxy)**： `method_missing`

```ruby
# calling method_missing infinitely
class Roulette
  def method_missing(name, *args)
    person = name.to_s.capitalize
    3.times do
      number = rand(10) + 1
      puts "#{number}..."
    end
    "#{person} got a #{number}"
  end
end
```

动态代理的问题：

* 命名冲突
  使用**白板类(blank slate)**
  - `Module#undef_method` 删除所有（包括继承来的）方法
  - `Module#remove_method` 删除接收者自己的方法，而保留继承来的方法
* 使用幽灵方法比普通方法慢

p.s.

```ruby
p BasicObject.instance_methods
=> [:==, :!=, :equal?, :!, :__send__, :instance_eval, :instance_exec]
```
