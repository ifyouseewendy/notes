###\# why multithread? 

Programs such as image processing software that perform a lot of calculations are said
to be **compute-bound**. They can only benefit from multithreading if there are actually
multiple CPUs to run computations in parallel. Most programs are not fully computebound,
however. Many, such as web browsers, spend most of their time waiting for
network or file I/O. Programs like these are said to be **IO-bound**. IO-bound programs
can be usefully multithreaded even when there is only a single CPU available. A web
browser might render an image in one thread while another thread is waiting for the
next image to be downloaded from the network.

+ **Ruby1.8**, for example, uses only a **single native thread**
and runs all Ruby threads within that one native thread. This means that in Ruby 1.8
threads are very lightweight, but that they never run in parallel, even on multicore
CPUs.

+ **Ruby1.9**, allocates a native thread for each Ruby thread. But because
some of the C libraries used in this implementation are **not themselves thread-safe**,
Ruby 1.9 is very conservative and never allows more than one of its native threads to
run at the same time.

- - -

###\# Thread Lifecycle

**Thread.new**, its synonyms are **Thread.start**, **Thread.fork**. The value of the Thread.new invocation is a **Thread object**.

**Thread#value** The value of the last expression in that block is the value of the thread,
and can be obtained by calling the **value** method of the Thread object. If the thread has
run to completion, then the value returns the thread’s value right away. Otherwise, the
value method blocks and does not return until the thread has completed.

**Thread.current** returns the Thread object that represents the current
thread. This allows threads to manipulate themselves. 

**Thread.main** returns the Thread object that represents the main thread—this is the initial thread of
execution that began when the Ruby program was started.

the Ruby interpreter stops running when the **main thread**
is done. It does this even if the main thread has created other threads that are still
running. You must ensure, therefore, that your main thread does not end while other
threads are still running.

+ One way to do this is to write your main thread in the form of an infinite loop. 
+ Another way is to explicitly wait for the threads you care about to
complete. You can call the **value** method of a thread to
wait for it to finish. If you don’t care about the value of your threads, you can wait with
the **join** method instead.

**unhandled exceptions**

+ If an exception is raised in the **main thread**, and is not handled anywhere, the Ruby interpreter prints a message and exits.
+ In threads other than the main thread, unhandled exceptions cause the thread to stop running. By default, however, this does not cause
the interpreter to print a message or exit.
+ If a thread t exits because of an unhandled exception, and another thread s calls t.join or t.value, then the exception that
occurred in t is raised in the thread s.

make any unhandled exception in any thread to cause the interpreter to exit.

    Thread.abort_on_exception = true

make unhandled exception in one particular thread to cause the interpreter to exit.

    t = Thread.new { ... }
    t.abort_on_exception = true

- - -

###\# Threads and Variables

+ **thread-private**, not visible to others.
+ **thread-local**, visible but not shared, each has own copy.

**thread-private**, variables **defined** within the block of a thread are private to that thread and are not visible to any other thread.

    # may be print 4, 4, 4
    n = 1
    while n <= 3
      Thread.new { puts n }
      n += 1
    end

    # x is variable defined within the block, is private to thread
    n = 1
    while n <= 3
      # Get a private copy of the current value of n in x
      Thread.new(n) {|x| puts x }
      n += 1
    end

**$SAFE** and **$~** are **thread-local**.

The Thread class provides hash-like behavior. It defines **[]** and **[]=** instance methods
that allow you to associate arbitrary values with any symbol. The values associated with these symbols behave like **thread-local** variables. They are not private like block-local variables because any thread can look up a value
in any other thread. But they are not shared variables either, since each thread can have
its own copy.

    Thread.current[:progress] = bytes_received

    total = 0
    Thread.list.each {|t| total += t[:progress] if t.key?(:progress) }

- - -

###\# Thread Scheduling

Ruby interpreters often have more threads to run than there are CPUs available to run
them. When true parallel processing is not possible, it is simulated by sharing a CPU
among threads. The process for sharing a CPU among threads is called **thread scheduling**.

**Thread#priority**, **Thread#priority=**. There is no way to set the priority of a thread before it starts running. A newly created thread starts at the same priority as the thread that created it. The main thread starts off at priority 0.

> thread priorities are dependent on the implementation
> of Ruby and on the underlying operating system. Under Linux, for example, nonprivileged
> threads cannot have their priorities raised or lowered. So in Ruby 1.9 (which
> uses native threads) on Linux, the thread priority setting is ignored.

When multiple threads of the same priority need to share the CPU, it is up to the thread scheduler to decide when, and for how long, each thread runs.

+ Some schedulers are preempting, which means that they allow a thread to run only for a fixed amount of time before allowing another thread of the same priority to run.
+ Other schedulers are not preempting: once a thread starts running, it keeps running unless it sleeps, blocks for I/O, or a higher-priority thread wakes up.

If a long-running compute-bound thread (i.e., one that does not ever block for I/O) is
running on a nonpreempting scheduler, it will **"starve"** other threads of the same priority,
and they will never get a chance to run. To avoid this issue, **long-running
compute-bound threads** should periodically call **Thread.pass** to ask the scheduler to
yield the CPU to another thread.

- - -

###\# Thread States

1. **Thread#status**

    Return value        Thread state
    'run'               Runnable
    'sleep'             Spleeping
    'aborting'          Aborting
    false               Terminated normally
    nil                 Terminated with exception

2. **Thread.stop**

  This is a class method that operates on the current thread—there is no equivalent instance method, so on thread cannot force another thread to pause. Calling Thread.stop is effectively the same thing as calling **Kernel.sleep** with no argument: the thread pauses forever (or until woken up).

  A thread that has paused itself with **Thread.stop** or **Kernel.sleep** can be started again
  (even if the sleep time has not expired yet) with the _instance methods_ **Thread#wakeup** and **Thread#run**.
  Both methods switch the thread from the sleeping state to the runnable state. The **run**
  method also invokes the thread scheduler. This causes the current thread to yield the
  CPU, and may cause the newly awoken thread to start running right away. The
  **wakeup** method wakes the specified thread without yielding the CPU.

  A thread can switch itself from the runnable state to one of the terminated states simply
  by exiting its block or by **raising an exception**. Another way for a thread to terminate
  normally is by calling **Thread.exit**.

  A thread can forcibly terminate another thread by invoking the _instance method_ **Thread#kill**
  on the thread to be terminated. **terminate** and **exit** are synonyms for **kill**. These
  methods put the killed thread into the **terminated normally** state. The killed thread runs
  any **ensure** clauses before it actually dies. The **kill!** method (and its synonyms
  **terminate!** and **exit!**) terminate a thread but **do not allow any ensure clauses to run**.

- - -

###\# Listing Threads and Thread groups

1. The **Thread.list** method returns an array of Thread objects representing all live (running
or sleeping) threads. When a thread exits, it is removed from this array.

2. If you want to impose some order onto a subset of threads, you can create a
**ThreadGroup** object and add threads to it:

        group = ThreadGroup.new
        3.times {|n| group.add(Thread.new { do_task(n) }}

        group.list

  The feature of the **ThreadGroup** class that makes it more useful than a simple array of
  threads is its enclose method. Once a thread group has been enclosed, threads may not
  be removed from it and new threads cannot be added to it. The threads in the group
  may create new threads, and these new threads will become members of the group. An
  enclosed ThreadGroup is useful when you run untrusted Ruby code under the $SAFE
  variable and want to keep track of any threads spawned by that code.

- - -

**Mutex** and **ConditionVariable** example

    #!/usr/bin/ruby
    require 'thread'
    mutex = Mutex.new

    cv = ConditionVariable.new
    a = Thread.new {
      mutex.synchronize {
        puts "A: I have critical section, but will wait for cv"
          cv.wait(mutex)
          puts "A: I have critical section again! I rule! - by www.yiibai.com"
      }
    }

    puts "(Later, back at the ranch...)"

    b = Thread.new {
      mutex.synchronize {
        puts "B: Now I am critical, but am done with cv"
          cv.signal
          puts "B: I am still critical, finishing up"
      }
    }
    a.join
    b.join

    # OUTPUT
    A: I have critical section, but will wait for cv
    (Later, back at the ranch...)
    B: Now I am critical, but am done with cv
    B: I am still critical, finishing up
    A: I have critical section again! I rule!
