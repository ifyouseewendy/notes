## ^ /  ~

^<n> select the nth *parent* of the commit (relevant in merges).
~<n> select the nth *ancestor* commit, always following the first parent.

        G   H   I   J
         \ /     \ /
          D   E   F
           \  |  / \
            \ | /   |
             \|/    |
              B     C
               \   /
                \ /
                 A
        A =      = A^0
        B = A^   = A^1     = A~1
        C = A^2  = A^2
        D = A^^  = A^1^1   = A~2
        E = B^2  = A^^2
        F = B^3  = A^^3
        G = A^^^ = A^1^1^1 = A~3
        H = D^2  = B^^2    = A^^^2  = A~2^2
        I = F^   = B^3^    = A^^3^
        J = F^2  = B^3^2   = A^^3^2

## .. / ...

    # logs on ref2 but ref1
    git log ref1..ref2
    git log ^ref1 ref2
    git log ref2 --not ref1

    # logs on both branches except the common node
    git log master...experiment
    git log --left-right master...experiment
