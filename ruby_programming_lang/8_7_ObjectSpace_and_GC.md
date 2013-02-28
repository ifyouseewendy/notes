**ObjectSpace.each_object**

    # Print out a list of all known classes
    ObjectSpace.each_object(Class) {|c| puts c }

- - -

**ObjectSpace.\_id2ref** is the inverse of **Object.object_id**: it takes an object ID as its
argument and returns the corresponding object, or raises a RangeError if there is no
object with that ID.

**ObjectSpace.define_finalizer** allows the registration of a Proc or a block of code to be
invoked when a specified object is garbage collected.

> The combination of the **_id2ref** and **define_finalizer** methods allows the definition
> of **"weak reference"** objects, which hold a reference to a value without preventing the
> value from being garbage collected if they become otherwise unreachable.

- - -

**ObjectSpace.garbage_collect** forces Ruby’ garbage collector to run. Garbage collection functionality is also available through the
GC module. **GC.start** is a synonym for ObjectSpace.garbage_collect. Garbage collection
can be temporarily disabled with **GC.disable**, and it can be enabled again with
**GC.enable**.
