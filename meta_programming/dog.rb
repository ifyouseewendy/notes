MSG = { :dance => 'is dancing', :poo => 'is a smelly doggy!', :laugh => 'finds this hilarious!' }

class Dog
  def initialize(name)
    @name = name
  end

  def can(*args)
    args.each do |arg|
      self.class.class_eval do
        define_method arg do
          puts "#@name #{MSG[arg]}"
        end
      end
    end
  end

  def method_missing(method, *args, &block)
    puts "#@name doesn't understand #{method}"
  end

end
