# Round Alias
class String
  alias :old_reverse :reverse

  def reverse
    "x#{old_reverse}x"
  end
end


# Blank Slate
class C
  def method_missing(name, *args)
    'a Ghost Method'
  end
end

obj = C.new
obj.to_s  # => "#<C:0x357258>"

class C
  instance_methods.each do |m|
    undef_method m unless m.to_s =~ /^(__|instance_eval|method_missing)/
  end
end

obj = C.new
obj.to_s  # => 'a Ghost Method'


# Class Extension Mixin
module M
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def my_method
      'a class method'
    end
  end
end

class C
  include M
end

C.my_method # => 'a class method'


# Class Instance Variable
class C
  @civ = 'hello world'

  class << self
    attr_accessor :civ
  end
end


# Sandbox
def sandbox(&code)
  Proc.new {
    $SAFE = 2
    yield
  }.call
end

begin
  sandbox { File.delete 'a_file' }
rescue Exception => ex
  ex  # => #<SecurityError: Insecure operation 'delete' at level 2>
end

# Self Yield
class Person
  attr_accessor :name, :surname

  def initialize
    yield self
  end
end

joe = Person.new do |p|
  p.name = 'Joe'
  p.surname = 'Smith'
end

# Symbol To Proc
class Symbol
  def to_proc
    Proc.new {|x| x.send(self) }
  end
end

[1,2,3,4].map(&:even?)

# Hash Initializer
module HashInitializer
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def hash_initializer(*attr_names)
      define_method(:initialize) do |*args|
        data = args.first || {}
        attr_names.each do |attr|
          instance_variable_set "@#{attr}", data[attr]
        end
      end
    end
  end
end

class A
  include HashInitializer

  hash_initializer :name, :age
  attr_accessor :name, :age
end

a = A.new(:name => 'wendi', :age => 11)

