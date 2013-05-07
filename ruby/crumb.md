## ruby-notes ##

### 1. tags.map(&:name)?

1. example

    ```ruby
    tags.map(&:name)

    # pass a proc to a method with the & syntax
    tags.map(&:name.to_proc)

    tags.map{ |tag| tag.name }
    ```

2. another example

    ```ruby
    ['foo', 'bar', 'blah'].map { |e| e.upcase }
    # => ['FOO', 'BAR', 'BLAH']

    block = proc { |e| e.upcase }
    block.call("foo") # => "FOO"

    block = proc { |e| e.upcase }
    ['foo', 'bar', 'blah'].map(&block)
    # => ['FOO', 'BAR', 'BLAH']

    ['foo', 'bar', 'blah'].map(&:upcase)
    # => ['FOO', 'BAR', 'BLAH']
    ```

3. `[1, 2, 3].inject(&:+)` can be omitted for `[1, 2, 3].inject(:+)`

### 2. Array#pack, String#unpack

* code

    ```ruby
    ["abc"].pack("a") => "a"
    ["abc"].pack("a*") => "abc"
    ["abc"].pack("a4") => "abc\0"

    "abc\0".unpack("a4") => ["abc\0"]
    "abc ".unpack("a4") => ["abc "]

    KEY_SEPARATORS = { :default => [0x1F].pack("c*"), :segment => [0x1E].pack("c*") }.freeze }
    ```

### 3. Array#in_groups, in_groups_of

* code

    ```ruby
    arr = [1, 2, 3, 4, 5, 6]
    arr.in_groups(3)    => [[1,2], [3,4], [5,6]]
    arr.in_groups_of(3) => [[1,2,3], [4,5,6]]

    arr << 7
    arr.in_groups(3)        => [[1,2,3], [4,5,nil], [6,7,nil]]
    arr.in_groups(3, false) => [[1,2,3], [4,5], [6,7]]
    arr.in_groups(3, 'a')   => [[1,2,3], [4,5,'a'], [6,7,'a']]

    arr.in_groups_of(3)         => [[1,2,3], [4,5,6], [7,nil,nil]]
    arr.in_groups_of(3, false)  => [[1,2,3], [4,5,6], [7]]
    arr.in_groups_of(3, 'a')    => [[1,2,3], [4,5,6], [7,'a','a']]
    ```

### 4. "*" splat operator

* as a right_value, to unpack an array
* as a left_value, to get an array

    ```ruby
    x,y,z=1,*[2,3]     # Same as x,y,z = 1,2,3

    *x,y=1,2,3          # x=[1,2]; y=3
    *x,y=1,2             # x=[1]; y=2
    *x,y=1                # x=[]; y=1

    # with parens
    x,y,z=1,[2,3]          # No parens: x=1;y=[2,3];z=nil
    x,(y,z)=1,[2,3]        # Parens: x=1;y=2;z=3
    ```

### 5. about equality

* `equal?`, checks actually the same object with the same `object_id`.
* `eql?`, checks for value, but **no type conversion**. `1.eql? 1.0 #=> false`
  - used in Hash to check equality of keys, Hash will check for `object_id` by default
  - if defined `eql?`, should define `hash` method too for generate hash code
* `==`, checks for value, **allowing type conversion**. `1 == 1.0 #=> true`
* `===`, checks for case equality. `Numeric === 1 #=> true`

