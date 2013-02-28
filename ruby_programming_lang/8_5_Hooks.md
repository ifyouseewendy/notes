+ included
+ extended
+ inherited
+ method_added
+ method_removed
+ method_undefined
+ singleton_method_added
+ singleton_method_removed
+ singleton_method_undefined
+ **method_missing** ( only one NO Class Methods )
+ **const_missing**


- - -

    module Final # A class that includes Final can't be subclassed
      def self.included(c) # When included in class c
        c.instance_eval do # Define a class method of c
          def inherited(sub) # To detect subclasses
            raise Exception, # And abort with an exception
                  "Attempt to create subclass #{sub} of Final class #{self}"
          end
        end
      end
    end

    def String.singleton_method_added(name)
      puts "New class method #{name} added to String"
    end

    # Including this module in a class prevents instances of that class
    # from having singleton methods added to them. Any singleton methods added
    # are immediately removed again.
    module Strict
      def singleton_method_added(name)
        STDERR.puts "Warning: singleton #{name} added to a Strict object"
        eigenclass = class << self; self; end
        eigenclass.class_eval { remove_method name }
      end
    end
