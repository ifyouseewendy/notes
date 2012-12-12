#### Class Variable

1. ***can be accessed in instance_methods***.
2. can be shared between inheritance, ***BUT behaves weird***.

#### Class Instance Variable

1. defined in class scope, ***cannot be accessed in instance_method***.
2. cannot be shared between inheritance, each class hold its own copy.
3. define

    ```ruby
    class A
      class << self
        attr_accessor :x
      end
    end
    A.x = 'x'
    A.x # => 'x'

    class AA < A; end
    AA.x # => nil
    ```

### example
- - -
* **Class Variable** only has one copy, and share it between inheritance

    ```ruby
    # <Class Varialbe> has only one copy, and share it between inheritance.
    class A1
      @@foo = 'foo'

      # in rails (all versions), cattr_accessor :foo is short for code below
      class << self
        def foo=(foo)
          @@foo = foo
        end
        def foo
          @@foo
        end
      end
    end

    A1.foo # => 'foo'

    class B1 < A1; end
    B1.foo # => 'foo'

    B1.foo = 'bar'
    B1.foo # => 'bar'
    A1.foo # => 'bar' !!! Annoying example!
    ```

- - -

* use **Class Instance Variable** instead

    ```ruby
    # Case 1
    class A2
      @foo = 'foo'

      class << self
        attr_accessor :foo
      end
    end

    A2.foo # => 'foo'

    class B2 < A2; end
    B2.foo # => nil ! No inheritance share

    B2.foo = 'bar'
    B2.foo # => 'bar'
    A2.foo # => 'foo'

    # Case 2
    #
    # defined in rails (<=3.1.0)
    class A3
      class_inheritance_accessor :foo
    end

    A3.foo = 'foo'

    class B3 < A3; end
    B3.foo # => 'foo' ! Compare between case 1

    B3.foo = 'bar'
    B3.foo # => 'bar'
    A3.foo # => 'foo'
    ```
