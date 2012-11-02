## &1. Numeric


1\. inheritance

  + code fragment

    ```ruby
    Numeric
       |
    Integer    Float    Complex    BigDecimal    Rational
       |
    Fixnum    Bignum    # auto-convert
    (<= 31bits)
    ```

2\. All numeric objects are **IMMUTABLE**. (method will never change its value)

3\. Fixnum

  + <1. different base

    ```ruby
    0b 0B => Binary
    0     => Octal
    0x 0X => Hexadecima
    ```

  + <2. __Integer values can also be indexed like arrays to query.__

    ```ruby
    a = 1_000_000
    a[0] => 0
    a[6] => 1
    ```

4\. Float-point Literals

  + <1. division __# Ruby always rounds towards -INFINITY__

    ```ruby
    7 / 3 => 2
    7 / -3 => -3 ( -2.33 -> -INFINITY )
    (-a/b) == (a/-b) != -(a/b)
    ```

  + <2. zero-division

    ```ruby
    Integer / 0 => ZeroDivisionError
    Float   / 0 => Infinity # (1.0/0).to_s == "Infinity"
    0.0     / 0 => Nan (Not a Number)
    ```

  + <3. module __# sign of the result depends on the second operand__

    ```ruby
    -7 % 2 => 1
    7 % -2 => -1
    ```

  + <4. exponentation _# right-to-left_

    ```ruby
    4 ** 3 ** 2 => 4 ** ( 3**2 )
    ```

  + <5. float-point is based on binary representations

    ```ruby
    0.4 - 0.3 != 0.1 (=> 0.10000003)
    # solution
    require 'bigdecimal'
    a = BigDecimal "0.4" # caution about type of param, String
    b = BigDecimal "0.3"
    c = a - b => "0.1E0"
    c.to_s("f") => "0.1" # "f" is for human reading
    ```


## &2. Text


1\. Strings are **MUTABLE** objects.

  + <1. __the Ruby interpreter cannot use the same object to represent two identical String objects.__

    ```ruby
    a = 1
    a.object_id => 3
    b = 1
    b.object_id => 3
    # n.object_id => 2n+1
    # false.object_id => 0
    # true.object_id => 2
    # nil.object_id => 4
    a = "1"
    a.object_id => 14658340 # random
    b = "1"
    b.object_id => 16878780
    b = a
    b.object_id => 14658340
    ````

  + <2. each time Ruby encounters a String literal it creates a new object.

    ```ruby
    3.times { puts "hello".object_id }
    ```

2\. single-quoted String

  + <1. in '', only need to escape itself.

  + <2. maybe '' is cold-blood, it is not sensative.

    ```ruby
    a = 'hello\
        world' => "hello\\\nworld"
    b = "hello\
        world" => "helloworld"
    ```

3\. double-quoted String

  + <1. String interpolation, like "#{..}".

    - {} can be omitted if the internal is a reference to a ___$global, @@class, @object___ variable.
    - to escape, use `\#{}` or `\#[$@]`

  + <2. sprintf

    ```ruby
    sprintf("pi is about %.4f", Math::PI) => "pi is about 3.1416"
    "pi is about %.4f" % Math::PI
    "%s %.4f" % ["pi is about", Math::PI]
    ```

  + <3. escape

    ```ruby
    "\unnnn" => "nnnn" is Unicode codepoint
    "\u{n}"
    "\nnn"   => octal digits between 000 ~ 377 ( 255 in decimal )
    "\xnn"   => hexa digits between 00 ~ FF
    ```

  + <4. %(Qq)

    ```ruby
    %q(helloworld) => 'helloworld'
    %Q-helloworld- => "helloworld"
    # % is short for %Q
    %~helloworld~  => "helloworld"
    ```

  + <5. here document ( << <<- )

    - begins on the next line.
    - << must ends at the beginning of the line, <<- no need.

      ```ruby
      str = <<HERE
      this is a line.
      this is another line.
      HERE
      => "this is a line.\nthis is another line.\n" # caution about the two \n
      ```

    - every here document ends with a line terminator, except "".

      ```ruby
      empty = <<END
      END
      => ""
      ```

    - ___special case___

      ```ruby
      greeting = <<HERE + <<THERE + "world"
      hello
      HERE
      new
      THERE
      => "hello\nnew\nworld"
      ```

  + <6. backtick

    - text in backtick passes to Kernel. method, executes and returns outputs as results.
    - %x `%x(ls)`

4\. Character literals

  + code fragment

    ```ruby
    # Ruby_1.8
    ?A => 65
    ?\t=> 9

    # Ruby_1.9
    ?A => 'A'
    ?\t=> "\t" # character literal for TAB character
    ?\u20AC => ?? # a Unicode character
    ```

5\. String operations

  + <1. + operator does not convert its righthand operand to string, do it yourself.

  + <2. [] can be used to read, insert, substitue, and delete.

  + <3. random access is less efficient than sequential access.

  + <4. literal Strings

    - Ruby_1.8, `each` for line iteration(=> 'line'), `each_char` for char iteration(=> 'c'), `each_byte` for byte iteration(=> ASCII num).
    - Ruby_1.9, `each_line` for line iteration, `each_char` for char iteration, `each_byte` for byte iteration.

  + <5. code fragment

    ```ruby
    a = "A"
    a << ?B => a is now "AB"
    a << 67 => a is now "ABC"
    a << 256 => Error in Ruby_1.8

    a = 0
    "#{a=a+1}" * 3 => "1 1 1", not "1 2 3"

    s = 'hello world'
    while s['l']
      s['l'] = 'L'
    end           => 'heLLo worLd'

    while s[/aeiou/]
      s[/aeiou/] = '*'
    end           => 'h*ll* w*rld'
    ```

6\. String encodings and multibyte Characters

  + Ruby_1.8, String is a sequence of bytes.

  + Ruby_1.9, String is a sequence of chars, no longer to map directly from character index to byte offset in the String.

    - ascii_only?
    - encoding, #force_encoding
    - the String literals encoding is not always the same as file encoding(# -*- coding: utf-8 -*-).

      ```ruby
      if literal contains only ASCII chars
          then its encoding is "ASCII"
      elsif literal contains "\u"
          then tis encoding is "UTF-8"
      end
      ```


## &3. Array


1\. Arrays are **MUTABLE** objects.

  + code fragment

    ```ruby
    a = [1, 2, 3]
    a.push 4  => [1, 2, 3, 4]
    a.pop     => [1, 2, 3]
    a.unshift => [4, 1, 2, 3[]]
    a.shift   => [1, 2, 3]
    ```

2\. %Ww is just like %Qq, and make array with Strings.


## &4. Hash


1\. Hashes are **MUTABLE** objects. (Hash#merge!)

2\. initialize

  + code fragment

    ```ruby
    h = Hash.new(0)
    h = { 1=2, 3=>4 }
    h = Hash[1,2,3,4]   => {1=>2, 3=>4}
    h = { 1,2, 3,4 }    => {1=>2, 3=>4} # Ruby_1.8, deprecate in Ruby_1.9
    h = { 1:2, 3:4 }    => {1=>2, 3=>4} # added in Ruby_1.9
    ```

3\. __Every hash key must have `hash` method.__ Hash compares keys with `eql?` method, which uses `hash` method to compare.

  + <1. if two keys are equal, they must have the same hashcode.

  + <2. unequal keys may also have the same hashcode, but hash tables are most efficient when duplicate hashcodes are rare.

4\. __Mutable objects are problematic as hash keys.__

  + <1. code fragment

    ```ruby
    a = [1, 2, 3]
    h = { a => 1 } => { [1,2,3] => 1 }
    a.pop
    p h            => { [1,2] => 1 }
    ```

  + <2. As String is so commonly used as Hash keys, Ruby treats Strings as a special case, and makes private copy of all Strings used as keys.

  + <3. if you use a mutable object as Hash key, make a private copy or call `freeze`.


## &5. Range


1\. `..` for [beg, end], `...` for [beg, end)

2\. __Range compares with &lt;=&gt;, and iterates based on `succ` method.__

  + code fragment

    ```ruby
    1.succ     => 2
    'a'.succ   => 'b'
    'Z'.succ   => 'AA'
    '9'.succ   => '10'
    'z9Z'.succ => 'aa0A'
    ```

3\. **comarison**

  + <1. `include?` and `member?` are synonyms,

  + <2. Ruby_1.8, `include?` implements based on comparison between beg and end values.

  + <3. Ruby_1.9, `cover?` behaves like `include?` in Ruby_1.8, and its `include?` behaves based on `cover?`, and then iterates(with #succ method) until the test value is found, which is **SLOW**.

    ```ruby
    triples = 'AAA'..'ZZZ'
    triples.include? 'ABC'  => true, fast in Ruby_1.8, slow in Ruby_1.9
    triples.include? 'ABCD' => true in Ruby_1.8, false in Ruby_1.9
    triples.cover? 'ABCD'   => true and fast in Ruby_1.9
    triples.to_a.include? 'ABCD' => just behaves like 'include?' in Ruby_1.9, false and slow in Ruby_1.8 and Ruby_1.9
    ```

  + <4. remember the parenthesis.

    ```ruby
    1..3.to_a   => wrong
    (1..3).to_a => right
    ```


## &6. Symbol


1\. Symbols are **IMMUTABLE** objects.

2\. `%s`

  + code fragment

    ```ruby
    %s(hello world) => :'hello world'`
    ```

3\. for comparison, Symbols behaves like integer(immutable object_id), __Symbols operation is relatively cheaper than Strings operation__, this is why Symbols are generally preferred to Strings as Hash keys.

4\. in Ruby_1.9, Symbol class defins a number of String methods, `length size [] =~`, this makes Symbols somewhat interchangeable with Strings, and allows their use as a kind of immutable (and not garbage-collected) String.

5\. true, false, nil refers to objects, they evalutes to a singleton instance of its class (TrueClass, FalseClass, NilClase).


## &7. Objects


1\. Object References

  + <1. assign with references

  + <2. methods with references

  + <3. __imediate values, Fixnum, Symbol.__

    - There is no way to tell that they are manipulated by value rather than reference.

  + <4. the only ___PRACTICAL DIFFERENCE___ between immediate values and reference values is that immediate values cannot have Singleton methods.


2\. Object Lifetime

  + <1. ___new___ is a method of Class class. It allocates memory to hold the new object, then it initializes the state of that newly allocated "empty" object by invoking its ___initialize___ method.

  + <2. Ruby objects never need to explicitly deallocated, cause GC will destroy objects that are unreachable automatically.


3\. Object Class and Object Type

  + code fragment

    ```ruby
    i = 1
    i.instance_of? Fixnum   => true
    i.instance_of? Integer  => false # instance_of? does not check inheritance
    i.is_a? Integer         => true  # is_a? does
    i.is_a? Comparable      => true  # is_a? also works with mixin modules
    i.kind_of? Numeric      => true  # kind_of? is a synonym for is_a?

    Numeric === i           => true  # equals i.is_a? Numeric
    i === Numeric           => false
    ```


4\. Object Equality

  + <1. __equal?__

    - the equal? method is defined by Object to test whether two values refer to exactly the same objects.

      ```ruby
      a = "ruby"
      b = c = "ruby"
      a.equal? b  => false
      b.equal? c  => true

      a.equal? b  <=> a.object_id == b.object_id
      ```

  + <2. __==__

    - in the Object class, it is simply the synonym for equal?, and it tests whethor two object references are identical.
    - most standard Ruby classes redefine this operator to implement a reasonable definition of equality, and to allow distinct instances to be tested for equality.

      ```ruby
      a = "ruby"
      b = "ruby"
      a == b  => true
      ```

    - two ___arrays___ are equal according to == if they have the same number of elements, and if their corresponding elements are all equal according to ==.
    - tow ___hashes___ equalily behaves like the arrays, __values are compared with == operator, but keys are compared with the eql? method__.
    - when Ruby sees !=, it simply uses the == operator and inverts the result.

  + <3. __eql?__

    - the eql? method is defined by Object as a synonym for equal?, Classes that overrides it typically use it as a strict version of == that does no type conversion.

      ```ruby
      1 == 1.0    => true
      1.eql? 1.0  => false
      ```

  + <4. __===__

    - the === operator is commomly called the "case equality" operator.
    - for many classes, case equality is the same as == equality, but certain key classes define === differently.

      ```ruby
      (1..10) === 5     => Range defines === to test whether a values falls within the range
      /\d+/   === "123" => Regexp defines === to test whether a string matches the regular expression
      String  === "s"   => Class defines === to test whether an object is an instance of that class
      :s === "s"        => true in Ruby_1.9
      ```

  + <5. __=~__

    - ___!~___ is defined as the inverse of the =~, and it is definable in Ruby_1.9, not in Ruby_1.8.


5\. Object Order

  + code fragment

    ```ruby
    1   <=> 5     => -1
    5   <=> 5     => 0
    9   <=> 5     => 1
    "1" <=> 5     => nil # if two operands cannot meaningfully compared, then results nil
    ```


6\. Object Conversion

  + <1. built-in methods do not typically invoke explicit conversion methods for you.
      - if you invoke a method that expects a String and pass an object of some other kind, that method is not expected to convert with ___to_s___ for you.

  + <2. in Ruby_1.8 only, ___Exception___ are string-like objects that can be treated as if they were strings.

    ```ruby
    e = Exception.new("not really an exception")
    msg = "error: " + e
    ```

  + <3. in Ruby_1.9 adds ___to_c___ and ___to_r___ methods to convert to Complex and Rational.

  + <4. in Ruby_1.9, the built-in class String, Array, Hash, Regexp, and IO all define a class method named ___try_convert___.

    ```ruby
    Array.try_convert(o)    => o.to_ary
    ```

  + <5. when Floating-point values convert to Numeric values, truncates rather than rounds.

  + <6. ___coerce___ method always returns an array that holds two numeric values of the same type.

    ```ruby
    1.coerce(1.1)   => [1.1, 1.0]

    require 'rational'
    r = Rational(1, 3)
    r.coerce(2)     => [Rational(2, 1), Rational(1, 3)]
    ```


7\. Copying Objects

  + <1. ___clone___ and ___dup___ return a shallow copy of the object on which they are invoked.

  + <2. if the object being copied defines an ***initialize_and_copy*** method, then ___clone___ and ___dup___ simply allocate a new, empyt instace of  the class and invoke ***initialize_and_copy*** method on this empty instance.

  + <3. ___DIFFERENCES___ between clone and dup

    - ___clone___ copies both frozen and tainted state, whereas ___dup___ only copies the tainted state. __SO__, _dup can unfreeze object in some way_.
    - ___clone___ copies any singleton methods of the objects, whereas dup does not.


8\. Marshaling Objects

  + <1. ___Marshal.dump___ and ___Marshal.load___ is __version-dependent__, and newer versions of Ruby are not guaranteed to be able to read marshaled objects written by older versions of Ruby.

  + <2. make ___deep copy___ of objects

    ```ruby
    def deep_copy(o)
        Marshal.load( Marshal.dump(o) )
    end
    ```

  + <3. ___files, I/O streams, Method and Binding___ objects are too dynamic to be marshaled.

  + <4. alternate to Marshal, YAML and JSON.

    - readable: YAML == JSON > Marshal
    - efficiency: Marshal > JSON> YAML

  + <5. an [article](http://www.skorks.com/2010/04/serializing-and-deserializing-objects-with-ruby/) about (de)serialization with ruby.



9\. Freezing Objects

  + <1. a frozen object becomes immutable. Freezing a class object prevents the addition of any methods to that class.

    ```ruby
    s = "ice"
    s.freeze
    s.forzen?   => true
    s.upcase!   => TypeError: cannot modify frozen String
    s[0] = "ni" => TypeError: cannot modify frozen String
    ```


10\. Tainted and Untrusted Objects

  + <1. Web applications must often keep track of data derived from untrusted user input to avoid SQL injection attacks and similar security risks.

  + <2. user input, such as command-line arguments, environment variables and strings read with ___gets___ - are automatically ___tainted___.

  + <3. when the global variable __$SAFE is set to a value greater than zero__, Ruby restricts various built-in methods so that they will not work with tainted data.

  + <4. in _Ruby_1.9_, objects can be untrusted in addition to beting tainted. Untrusted code creates untrusted, tainted objects and is not allowed to modify trusted objects.

    ```ruby
    freeze  |  frozen?    |  (dup)
    taint   |  tainted?   |  untaint
    trust   |  trusted?   |  untrust
    ```

