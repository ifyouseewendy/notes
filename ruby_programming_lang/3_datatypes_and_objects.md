## &1. Numeric

1. inheritance

    ```ruby
    Numeric
       |
    Integer    Float    Complex    BigDecimal    Rational
       |
    Fixnum    Bignum    # auto-convert
    (<= 31bits)
    ```

2. All numeric objects are **IMMUTABLE**. (method will never change its value)

3. Fixnum

+ <1. different base

    ```ruby
    0b 0B => Binary
    0     => Octal
    0x 0X => Hexadecima
    ```

+ <2. _Integer values can also be indexed like arrays to query._

    ```ruby
    a = 1_000_000
    a[0] => 0
    a[6] => 1
    ```

4\. Float-point Literals

+ <1. division ___# Ruby always rounds towards -INFINITY___

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

+ <3. module ___# sign of the result depends on the second operand___

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

+ ___the Ruby interpreter cannot use the same object to represent two identical String objects.___

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

  - each time Ruby encounters a String literal it creates a new object.

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
  - _{} can be omitted if the internal is a reference to a **$global, @@class, @object** variable._
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

  - _special case_

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

+ <1. example 

    ```ruby
    # ruby_1.8
    ?A => 65
    ?\t=> 9

    #ruby_1.9
    ?A => 'A'
    ?\t=> "\t" # character literal for TAB character
    ?\u20AC => ?? # a Unicode character
    ```

5\. String operations

+ <1. + operator does not convert its righthand operand to string, do it yourself.
+ <2. [] can be used to read, insert, substitue, and delete.
+ <3. random access is less efficient than sequential access.
+ <4. literal Strings
  - ruby_1.8, `each` for line iteration(=> 'line'), `each_char` for char iteration(=> 'c'), `each_byte` for byte iteration(=> ASCII num).
  - ruby_1.9, `each_line` for line iteration, `each_char` for char iteration, `each_byte` for byte iteration.
+ <5. example

    ```ruby
    a = "A"
    a << ?B => a is now "AB"
    a << 67 => a is now "ABC"
    a << 256 => Error in ruby_1.8

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

+ ruby_1.8, String is a sequence of bytes.

+ ruby_1.9, String is a sequence of chars, no longer to map directly from character index to byte offset in the String.

  - #ascii_only?
  - #encoding, #force_encoding
  - the String literals encoding is not always the same as file encoding(# -*- coding: utf-8 -*-).

      if literal contains only ASCII chars
        then its encoding is "ASCII"
      elsif literal contains "\u"
        then tis encoding is "UTF-8"
      end

___

7\. Array

+ <1. Arrays are **MUTABLE** objects.

    ```ruby
    a = [1, 2, 3]
    a.push 4  => [1, 2, 3, 4]
    a.pop     => [1, 2, 3]
    a.unshift => [4, 1, 2, 3[]]
    a.shift   => [1, 2, 3]
    ```

+ <2. %Ww is just like %Qq, and make array with Strings.

8\. Hash

+ <1. Hashes are **MUTABLE** objects. (Hash#merge!)
+ <2. initialize

    ```ruby
    h = Hash.new(0)
    h = { 1=2, 3=>4 }
    h = Hash[1,2,3,4]   => {1=>2, 3=>4}
    h = { 1,2, 3,4 }    => {1=>2, 3=>4} # ruby_1.8, deprecate in ruby_1.9
    h = { 1:2, 3:4 }    => {1=>2, 3=>4} # added in ruby_1.9
    ```

+ <3. ___Every hash key must have `hash` method.___ Hash compares keys with `eql?` method, which uses `hash` method to compare.
  - if two keys are equal, they must have the same hashcode.
  - unequal keys may also have the same hashcode, but hash tables are most efficient when duplicate hashcodes are rare.

+ <4. ___Mutable objects are problematic as hash keys.___

    ```ruby
    a = [1, 2, 3]
    h = { a => 1 } => { [1,2,3] => 1 }
    a.pop
    p h            => { [1,2] => 1 }
    ```

  - As String is so commonly used as Hash keys, Ruby treats Strings as a special case, and makes private copy of all Strings used as keys.
  - if you use a mutable object as Hash key, make a private copy or call `freeze`.

9\. Range

+ <1. `..` for [beg, end], `...` for [beg, end)

+ <2. ___Range compares with &lt;=&gt;, and iterates based on `succ` method.___


    ```ruby
    1.succ     => 2
    'a'.succ   => 'b'
    'Z'.succ   => 'AA'
    '9'.succ   => '10'
    'z9Z'.succ => 'aa0A'
    ```

+ <3. ___comarison___
  - `include?` and `member?` are synonyms,
  - ruby_1.8, `include?` implements based on comparison between beg and end values.
  - ruby_1.9, `cover?` behaves like `include?` in ruby_1.8, and its `include?` behaves based on `cover?`, and then iterates(with #succ method) until the test value is found, which is **SLOW**.

      ```ruby
      triples = 'AAA'..'ZZZ'
      triples.include? 'ABC'  => true, fast in 1.8, slow in 1.9
      triples.include? 'ABCD' => true in 1.8, false in 1.9
      triples.cover? 'ABCD'   => true and fast in 1.9
      triples.to_a.include? 'ABCD' => just behaves like 'include?' in 1.9, false and slow in 1.8 and 1.9
      ```

+ <4. remember the parenthesis.

    ```ruby
    1..3.to_a   => wrong
    (1..3).to_a => right
    ```

10\. Symbol

+ <1. Symbols are **IMMUTABLE** objects.
+ <2.

    ```ruby
    %s(hello world) => :'hello world'`
    ```

+ <3. for comparison, Symbols behaves like integer(immutable object_id), ___Symbols operation is relatively cheaper than Strings operation___, this is why Symbols are generally preferred to Strings as Hash keys.
+ <4. in ruby_1.9, Symbol class defins a number of String methods, `length size [] =~`, this makes Symbols somewhat interchangeable with Strings, and allows their use as a kind of immutable (and not garbage-collected) String.
+ <5. true, false, nil refers to objects, they evalutes to a singleton instance of its class (TrueClass, FalseClass, NilClase).
