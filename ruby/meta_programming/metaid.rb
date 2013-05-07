class Object

  # The hidden singleton lurks behind everyone
  def metaclass
    class << self; self; end;
  end
  def meta_eval &blk
    metaclass.instance_eval &blk
  end

  # Adds methods to a metaclass
  def meta_def name, &blk
    meta_eval { define_method name, &blk }
  end

  # Define an instance_method within a class
  def class_def name, &blk
    class_eval { define_method name, &blk }
  end

  # --------------------------------------
  # WHAT I AM I CONFUSING ?
  #
  # class A; end
  # a = A.new
  # b = a.metaclass
  #
  # a.meta_eval { def foo; puts 'foo'; end }
  # =>  works b.foo
  #
  # a.meta_eval { define_method :bar do puts 'bar'; end }
  # =>  works a.bar
  #

end
