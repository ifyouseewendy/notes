### 7.4.3 dup, clone and initialize_copy
- - -

**dup and clone both do shallow copy**

* `dup` copy: instance_variables, taintedness
* `clone` copy: instance_variables, taintedness + frozen, singleton_methods 
* - - - - - - - - -
* `initialize_copy`
  - calls after dup
  - calls before clone (change the original object)

* a **Enumerated class which limits the number of instacens** should make `new` method private, and prevent copies being made.

    ```ruby
    class Season
      NAMES = %w{ Spring Summer Autumn Winter }
      INSTANCES = []

      def initialize(n)
        @n = n
      end

      def to_s
        NAMES[@n]
      end

      NAMES.each_with_index do |name, index|
        instance = new(index)
        INSTANCES[index] = instance
        const_set name, instance
      end

      private_class_method :new, :allocate

      # you can also `undef :dup, :clone`
      # or better to redefine :dup and :clone to raise exception to notify users
      private :dup, :clone
    end

    Season::INSTANCES   # => [Spring, Summer, Autumn, Winter]
    Season::Spring.to_s # => "Spring"
    ```

### 7.4.4 write a Singleton class
- - -

* Singleton module automatically creates the `instance` class method.

    ```ruby
    require 'singleton'

    class Stats
      include Singleton

      def initialize
        @sum, @count = 0, 0
      end

      def record(n)
        @sum += n
        @count += 1
      end

      def report
        puts "Sum of numbers is: #@sum"
        puts "Count of numbers is: #@count"
        puts "Average of numbers is: #{(@sum.to_f/@count).round(1)}"
      end
    end

    Stats.instance.record(10)
    Stats.instance.record(20)
    Stats.instance.record(30)

    Stats.instance.report
    ```



