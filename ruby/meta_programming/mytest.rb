class A

  def foo1
    p 'foo1 from A'
  end

  define_method :bar1 do
    p 'bar1 from A'
  end

end

def test
  a = A.new

  puts '------------'
  a.foo1
  a.bar1

  puts '------------'
  begin
    a.instance_eval { def foo2; puts 'foo2 from a.metaclass'; end }
    a.instance_eval { define_method :bar2 do; puts 'bar2 from a.metaclass'; end }
  rescue => e
    p e
  end

  puts '------------'
  aa = class << a; self; end
  begin
    aa.instance_eval { def foo3; puts 'foo3 from a.metaclass.metaclass'; end }
    aa.instance_eval { define_method :bar3 do; puts 'bar3 from a.metaclass.metaclass'; end }
  rescue => e
    p e
  end
end
