```ruby
# target
class Person
  include CheckedAttributes

  attr_checked :age do |v|
    v >= 18
  end
end

me = Person.new
me.age = 39  # => OK
me.age = 12  # => raise Exception

# code
module CheckedAttributes
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def attr_checked(attr, &validation)
      define_method(attr) do
        instance_variable_get("@#{attr}")
      end
      define_method("#{attr}=") do |value|
        raise "Invalid attribute" unless validation.call(value)
        instance_variable_set("@#{attr}", value)
      end
    end
  end
end

```
