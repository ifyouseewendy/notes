class DataWrapper

  def self.wrap(file_name)

    class_name = File.basename(file_name, '.txt').capitalize
    klass = Object.const_set(class_name, Class.new)

    data = File.new(file_name)
    header = data.gets.chomp
    data.close

    names = header.split(',')

    klass.class_eval do
      attr_accessor *names

      define_method :initialize do |*args|
        names.each_with_index do |name, i|
          instance_variable_set("@#{name}", args[i])
        end
      end

      define_method :to_s do
        str = "<#{self.class}:"
        names.each {|name| str << " #{name}=#{self.send(name)}" }
        str << ">"
      end

      alias_method :inspect, :to_s

    end

    def klass.read
      data = File.new(self.to_s.downcase + '.txt')
      data.gets

      array = []
      data.each do |line|
        line.chomp!
        values = eval("[#{line}]")
        array << self.new(*values)
      end
      data.close
      array
    end

    klass
  end

end
