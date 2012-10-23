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

1. Strings are **MUTABLE** objects.

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

2. single-quoted String

+ <1. in '', only need to escape itself.

+ <2. maybe '' is cold-blood, it is not sensative.

    ```ruby
    a = 'hello\
        world' => "hello\\\nworld"
    b = "hello\
        world" => "helloworld"
    ```

3. double-quoted String

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

+ <6. backtick __`__
  - text in backtick passes to Kernel.` method, executes and returns outputs as results.
  - %x `%x(ls)`





