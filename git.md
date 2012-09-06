## ^ /  ~

^  one of the merged parent's nodes
^2 the other one of the merged parent's nodes

~  father's node
~~ father's father's node
~2 father's father's node

    git log HEAD^^
    git log HEAD~~
    git log HEAD~2
    # not equal above
    git log HEAD^2

## .. / ...

    # logs on ref2 but ref1
    git log ref1..ref2
    git log ^ref1 ref2
    git log ref2 --not ref1

    # logs on both branches except the common node
    git log master...experiment
    git log --left-right master...experiment
