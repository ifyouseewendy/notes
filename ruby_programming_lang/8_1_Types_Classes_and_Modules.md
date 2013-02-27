
    module A; end # Empty module
    module B; include A; end; # Module B includes A
    class C; include B; end; # Class C includes module B

    A.ancestors       # => [A]
    B.ancestors       # => [B, A]
    C.ancestors       # => [C, B, A, Object, Kernel]
    String.ancestors  # => [String, Enumerable, Comparable, Object, Kernel]

    C < B             # => true: C includes B
    C.include?(B)     # => true
    A.include?(A)     # => false

    A.included_modules # => []
    B.included_modules # => [A]
    C.included_modules # => [B, A, Kernel]

- - -

The class method **Module.nesting** is not related to module inclusion or ancestry; instead,
it returns an array that specifies the nesting of modules at the current location.
**Module.nesting[0]** is the current class or module, **Module.nesting[1]** is the containing
class or module.

    module M
      class C
        Module.nesting # => [M::C, M]
      end
    end

- - -

    M = Module.new      # Define a new module M
    C = Class.new       # Define a new class C
    D = Class.new(C) {  # Define a subclass of C
      include M         # that includes module M
    }
    D.to_s              # => "D": class gets constant name by magic

One nice feature of Ruby is that when a dynamically created anonymous module or
class is assigned to a constant, the name of that constant is used as the name of the
module or class (and is returned by its name and to_s methods).
