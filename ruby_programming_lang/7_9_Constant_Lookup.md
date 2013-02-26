**Constant Lookup**
- - -

- Constants defined in **enclosing modules** are found in preference to constants
defined in **included modules**.
- The **modules included** by a class are searched before the **superclass** of the class.
- The **Object** class is part of the inheritance hierarchy of all classes. Top-level constants,
  defined outside of any class or module, are like top-level methods: they are
  implicitly defined in Object. When a top-level constant is referenced from within
  a class, therefore, it is resolved during the search of the inheritance hierarchy. If
  the constant is referenced within a module definition, however, an explicit check
  of Object is needed after searching the ancestors of the module.
- The **Kernel** module is an ancestor of Object. This means that constants defined in
  Kernel behave like top-level constants but can be overridden by true top-level
  constants, that are defined in Object.

        module Kernel
          # Constants defined in Kernel
          A = B = C = D = E = F = "defined in kernel"
        end

        # Top-level or "global" constants defined in Object
        A = B = C = D = E = "defined at toplevel"

        class Super
          # Constants defined in a superclass
          A = B = C = D = "defined in superclass"
        end

        module Included
          # Constants defined in an included module
          A = B = C = "defined in included module"
        end

        module Enclosing
          # Constants defined in an enclosing module
          A = B = "defined in enclosing module"

          class Local < Super
            include Included

            # Locally defined constant
            A = "defined locally"

            # The list of modules searched, in the order searched
            # [Enclosing::Local, Enclosing, Included, Super, Object, Kernel]
            search = (Module.nesting + self.ancestors + Object.ancestors).uniq

            puts A # Prints "defined locally"
            puts B # Prints "defined in enclosing module"
            puts C # Prints "defined in included module"
            puts D # Prints "defined in superclass"
            puts E # Prints "defined at toplevel"
            puts F # Prints "defined in kernel"
          end
        end
