MSG = { :dance => 'is dancing', :poo => 'is a smelly doggy!', :laugh => 'finds this hilarious!' }

class Dog
  def initialize(name)
    @name = name
  end

  def can(*args, &block)
    args.each do |arg|
      eigen_class = class << self; self; end
      instance_name = @name
      Object.class_eval do
        define_method "name" do
          instance_name
        end
      end
      eigen_class.class_eval do
        define_method arg do
          block ? block.call : "#@name #{MSG[arg]}"
        end
      end
    end
  end

  def method_missing(method, *args, &block)
    "#@name doesn't understand #{method}"
  end

end

