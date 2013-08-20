### WORKING WITH UNIX PROCESSES

#### APIs
- - -

```
Process.pid
Process.ppid

File.open('/etc/passwd').fileno

Process.getrlimit(:NOFILE) 		# :FSIZE, :NPROC, :STACK

ARGV.include?('--help')
ARGV.include?('-c') && ARGV[ARGV.include?('-c')+1]

$PROGRAM_NAME					# => 'pry'
$0 								# => 'pry'
```

#### PRIMER
- - -

most commonly used sections of the manpages for FreeBSD and Linux:

1. Section 1: General Commands
2. Section 2: System calls
3. Section 3: C Library Functions
4. Section 4: Special Files

#### Processes Habe File Descriptors
- - -

pids represennt running processes, and file descriptors represent open files.

1. File descriptor numbera are assigned the lowest unused value.
2. Once a resource is closed its file descriptor number becomes available again.
3. Only open resources have file descriptors.

```
passwd = File.open('/etc/passwd')
puts passwd.fileno 		# => 3

passwd.close
puts passwd.fileno 		# => closed stream (IOError)
```

```
puts STDIN.fileno		# => 0
puts STDOUT.fileno 		# => 1
puts STDERR.fileno		# => 2
```

#### Processes Have Resource Limits
- - -

**NOFILE**

```
Process.getrlimit(:NOFILE)		# => [$soft_limit, $hard_limit]
```

when exceeded soft limits, an exception will raised, but you can always change the limit if you want to.

```
Process.setrlimit(:NOFILE, 3)

File.open('/dev/null')	# => Errno::EMFILE: Too many open files
```

**OTHERS**

```
 # max number of simultaneous processes allowed for the current user
Process.getrlimit(:NPROC)

 # The largest size file that may be created
Process.getrlimit(:FSIZE)

 # man size of the stack segment of the process
Process.getrlimit(:STACK)

```

#### Processes Have Exit Codes
- - -

**exit**

```
 # exit program with success status code (0)
exit

 # exit program with custom status code
exit 22

 # When Kernel#exit is invoked, before exiting invokes any blocks defined by Kernel#at_exit
at_exit { puts 'bye' }
exit
```

**exit!**

1. sets an unsuccessful status code by default (1)
2. will not invoke any blocks defined by `Kernel#at_exit`

**abort**

set the exit code to 1 by default, and you can pass a message to it, and it'll be printed into `STDERR`

```
 # at_exit are invoked when using abort
at_exit { puts 'bye' }
abort "Something went horribly wrong."
```

**raise**

1. set exit code to 1
2. invoke `at_exit` handler
3. print exception message and backtrace to `STDERR`

#### Processes Can Fork
- - -

> **The child process inherits a copy of all of the memory in use by the parent process, as well as any open file descriptors belonging to the parent process.**

it means that, two processes can share open files, sockets, etc.

One call to `fork` method actually returns twice.

1. returns child-process pid in parent-process
2. returns `nil` in child-process

```
if fork
	puts 'parent entered.'
else
	puts 'child entered.'
```

There's no guarantee that when you `fork` 4 new processes and each process by a seperate CPU.

**attention about the _FORK BOMB_**

when passing a block to the `fork`, that the block will be executed in the new child-process, and the parent-process simply skips over it.

```
fork do
	puts 'child enters here'
end

puts 'parent skips over'

```

#### CoW: copy-on-write
- - -


> **CoW**: Parent-process and child-process will share the same physical data in memory until one of them needs to modify it, at which point the memory will be copied so that proper seperation between the two processes can be preserved.

It's not supported in **MRI** or **Rubinius**, and **REE** supported.

Because **MRI**'s garbage collector uses a 'mark-and-sweep' algorithm. When **GC** invoked, every known object will be written to marked that whether it'll be garbage collected. So, after forking, the first time that **GC** runs will retract the benefit that copy-on-write provides.

#### Processes Can Wait
- - -

**fire and forget**, is when parent-process exited before the child-process. It's useful when you want a child-process to handle something asynchronously, but the parent still has its own work to do.

**Process.wait**

`Process.wait` is a blocking call instructing the parent process to wait for **one of its child processes** to exit before continuing.

```
fork do
	5.times do
		sleep 1
		puts 'I am an orphan?'
	end
end

Process.wait
abort 'Kids, you are not alone!'

- - -

3.times do
	fork do 
		sleep(5)
	end
end

3.times do
	puts Process.wait
end
```

**Process.wait2**

as `wait` returns the child process pid, `wait2` returns 2 values (pid, status).

This status can be used as communication between processes via exit codes. The status returned is an instance of `Process::Status`.

```
 # communication between processes without filesystem and network!
5.times do
	fork do
		if rand(5).even?
			exit 111
		else
			exit 112
		end
	end
end

5.times do
	pid, status = Process.wait2
	
	if status.exitstatus == 111
		puts "#{pid} encountered on even number!"
	else
		puts "#{pid} encountered on odd number!"
	end
end
```

**Process.waitpid & Process.waitpid2**

Both `wait` and `waitpid` aliased to the same thing.

```
Process.wait 111 	# <=> Process.waitpid 111

Process.waitpid -1 	# <=> Process.wait
```

**Race Conditions**

```
2.times do
	fork do
		abort 'Finished!'r
	end
end

puts Process.wait
sleep 5

puts Process.wait
```

**The kernel queues up information about exited processes so that parent always receives the information in the order that children exited.** This technique is free from race conditions.

Calling any variant of `Process.wait` when there are no child processes will raise `Errno::ECHILD`.


#### Zombie Processes
- - -

> The kernel queues up information about exited processes.

So the kernel retain the status of exited child processes until the parent process requests that status using `Process.wait`. Creating **fire and forget** child-processes without collecting their status information is a poor use of kernel resource.

Any dead process whose status hasn't been waited on is a **zombie process**.


\      | zombie | daemon |
------ | ------ | ------ |
parent | active | dies   |
child  | dies   | active |


Two ways to avoid **zombie-process**:

1. `Process.wait`
2. `Process.detach(pid)`, it simply spawns a new thread those sole job is to wait for the child process specified by `pid` to exit.

#### Processes Can Get Signals
- - - 

Signal delivery is unreliable, when handling with `:CHLD` signal, if the child process dies you may or may not receive a **second** `:CHLD` signal.

This behaviour only happens when receiving the same signal several times in quick succession, **you can always count on at least one instance of the signal arriving**.

To properly handle `:CHLD` you must call `Process.wait` in a loop and look for as many dead child processes as are possible. But `Process.wait` is a blocking call…

`Process.wait(-1, Process::WNOHANG)`, take another param, to tell the kernel not to block if no child has exited.

```
child_processes = 3
dead_processes = 0

child_processes.times do
	fork do
		sleep 3
	end
end

 # always a good idea to do this is your handlers will be doing IO
STDOUT.sync = true

trap(:CHLD) do
	begin
		while pid = Process.wait(-1, Process::WNOHANG)
			puts pid
			dead_processes += 1
			
			exit if dead_processes == child_processes
		end
	rescue Errno::ECHILD
	end
end

loop do
	puts 'parent working…'
	sleep 1
end
```

It's possible for the last `:CHLD` signal to arrive after the previous `:CHLD` handler has already called `Process.wait` twice and gotten the last available status. Any line of code can be interrupted with a signal.

**Where do Signals Come From?**

> Signals are sent from process to another process, using the kernel as a middleman.

**Redefining Signals**

```
puts Process.pid
trap(:INT) { print 'hello, u got trapped by me' }
sleep
```

**Ignoring Signals**

```
puts Proceess.pid
trap(:INT, "IGNORE")
sleep
```

#### Processes Can Communicate

**IPC, inter-process communication**

+ **Pipe** hold a **stream** of data.
+ **Pipe** is a **uni-directional stream*** of data.

```
reader, writer = IO.pipe
writer.write("Into the pipe I go…")
writer.close
puts reader.read
```

close the pipe, because IO#read will continue reading data until it sees an EOF.

**Sharing Pipes**

```
reader, write = IO.pipe

fork do
	reader.close
	
	10.times do
		writer.puts "Another one bites the dust"
	end
end

writer.close
while message = reader.gets
	STDOUT.puts message
end
```

the unused ends of the pipe are closed so as not to interfere with EOF being sent.

**Pipes hold a stream of data**

When saying stream, it means that when writing and reading data to a pipe there's no concept of beginning and end. When working with an IO stream, you write your data to the stream followed by some protocal-specific delimter.

So with pipes, you can use `#puts` and `#gets` which used a  newline as the delimiter.

**A socket pair provids bi-directional communication.**

#### Daemon Processes
- - -

**Daemon processess** are processes that run in the background, **rather than under the control of a user at a terminal**. Common examples are web servers or database server.

> When the kernel is bootstrapped it spawns a process called the `init` process, which `pid` is 1, and `ppid` is 0.

**create daemon processes**

```
def daemonize_app
	if RUBY_VERSION < '1.9'
		exit if fork
		Process.setsid
		exit if fork
		Dir.chdir '/'
		STDIN.reopen '/dev/null'
		STDOUT.reopen '/dev/null', 'a'
		STDERR.reopen '/dev/null', 'a'
	else
		Process.daemon
	end
end
```

**Process Groups**

Process group is a collection of related processes, typically a parent process and its children, and the process group id will be the same as the pid of the process group leader.

+ **when a parent process exits**, the child will continue on.
+ **when a parent is killed by a signal**, the terminal would forward it on to any process in the foreground process group.

So when a Ruby script that shells out a long-running shell command, when Ctrl-C is sent, as both the Ruby script and long-running shell command would are part of the same process group, they would both be killed by the same signal.

**Session Groups**

Session group is a collection of process groups.

```
git log | grep ruby | less
```

Each command will get its own process group, but one Ctrl-C will kill them all. It's because these commands are part of the same session group. **Each invocation from the shell will gets its own session group.**

**Process.setsid**

1. The process becomes a session leader of a new session.
2. The process becomes the process group leader of a new process group.
3. The process has no controlling terminal.
4. Note that `setsid` will fail in a process that is already a process group leader, it can only be run from child processes.

**explain the code snipets above**

1. the first `exit if fork` ensures the parent exits, but child continues.
2. as the child stills has the same process group id and session id as the parent, so `Process.setsid` makes a new session, without a controlling terminal, but **technically one could be assigned**.
3. the second `exit if fork`, the newly forked process is no longer a process group leader nor a session leader. Since the previous session leader had no controlling terminal, and this process is not a session leader, it's guaranteed that this process can never have a controlling terminal. **Terminals can only be assigned to session leader**.
4. `Dir.chdir '/'` ensures the current working directory of daemon doesn't disappear during its execution.
5. the lefts,  sets all of the standard streams to be ignored. Redirecting them to `/dev/null` ensures that they're still avaiable to the program but have no effect.

**Does this process need to stay responsive forever?**

+ no, maybe a cron job or a background job fits
+ yes, daemon process.

#### Spawning Terminal Processes

**`fork + exec`**

`exec(2)` allows you to replace the current process with a different process, to transform the current process into any other process.

When use the `exec` in ruby, it use the `fork(2) + exec(2)` combo.

Keep in mind that `exec(2)` doesn't close any open file descriptors or do any memory cleanup.

**arguments to exec**

+ when passing a `string`, it will actually start up a shell process and pass the string to the shell to interpret.
+ when passing a `array`, it will skip the shell and set up the array directly as the `ARGV` to the new process.

Generally pass an array where possible.

**Kernel#system**

return value: if the exit code was 0, returns true, otherwise returns false.

```
ret = system('ls') 		# => true
```

**Kernel#`**

```
ret = `ls`				# => "Documents\nPix\n…"
%x(git log | tail -10)
```

return value: the `STDOUT` of the terminal program collected into a String.

It's using `fork(2)` under the hood, and doesn't do anything special with `STDERR`.

```
ret = `ls --wendi`  

 # ls: illegal option -- -  
 # usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]
 
ret # => ''
```

**Process.spawn**

+ `Kernel#system` will block until the comand is finished.
+ `Process.spawn` will return immediately.

```
 # Ruby 1.9 only!
 
Process.spawn({'RAILS_ENV' => 'test'}, 'rails server')

Process.spaws('ls', '--wendi', STDERR => STDIN)

 # Do it the bloking way
system 'sleep 5'

 # Do it the non-blocking way
Process.spawn 'sleep 5'

 ＃ Do it the blocking way with Process.spawn
 # Notice that it returns the pid of the child process
def foo
	pid = Process.spawn 'sleep 5'
	Process.waitpid(pid)
	puts 'end'
end
```

**IO.popen**

The most common usage for `IO.popen` is an implementation of Unix pipes in pure Ruby. Underneath is still doing the `fork+exec`， but it's also setting up a pipe to communicate with the spawned process. That pipe is passed as the block argument in the block form of `IO.popen`.

```
p = IO.popen('ls')
p.read

IO.popen('tmp', 'w') { |stream|
	stream.puts 'some data'
}
```

**With `IO.popen` you have to choose which stream you have access to. You can't access them at once.

**Open3**

`Open3` allows simultaneous access to the `STDIN`, `STDOUT`, `STDERR` of a spawned process.

```
require 'open3'

Open3.popen3('grep', 'data') { |stdin, stdout, stderr|
	stdin.puts 'some data'
	stdin.close
	puts stdout.read
}

 # Open3 will use Process.spawn when available.
Open3.popen3('ls', '-uhh', :err => :out) { |stdin, stdout, stderr|
	puts stdout.read
}
```	