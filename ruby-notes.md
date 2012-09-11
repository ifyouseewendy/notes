## ruby-notes ##

### 1. tags.map(&:name)?

<1.
        tags.map(&:name)

        # pass a proc to a method with the & syntax
        tags.map(&:name.to_proc)

        tags.map{ |tag| tag.name }

<2. another example

        ['foo', 'bar', 'blah'].map { |e| e.upcase }
        # => ['FOO', 'BAR', 'BLAH']

        block = proc { |e| e.upcase }
        block.call("foo") # => "FOO"

        block = proc { |e| e.upcase }
        ['foo', 'bar', 'blah'].map(&block)
        # => ['FOO', 'BAR', 'BLAH']

        ['foo', 'bar', 'blah'].map(&:upcase)
        # => ['FOO', 'BAR', 'BLAH']

<3. [1, 2, 3].inject(&:+) can be omitted for [1, 2, 3].inject(:+).

