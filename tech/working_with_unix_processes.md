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