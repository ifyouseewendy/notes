    s.slice(0,5) # Same as s[0,5]. Returns a substring.
    s.slice!(5,6) # Deletion. Same as s[5,6]="". Returns deleted substring.

    s.rindex('l') # => 3: index of rightmost l in string
    s.rindex('l',2) # => 2: index of rightmost l in string at or before 2

    # Split a string into two parts plus a delimiter. Ruby 1.9 only.
    # These methods always return arrays of 3 strings:
    "banana".partition("an") # => ["b", "an", "ana"]
    "banana".rpartition("an") # => ["ban", "an", "a"]: start from right
    "a123b".partition(/\d+/) # => ["a", "123", "b"]: works with Regexps, too

    s.sub!(/(.)(.)/, '\2\1') # => "ehllo": Match and swap first 2 letters
    s.sub!(/(.)(.)/, "\\2\\1") # => "hello": Double backslashes for double quotes

    # sub and gsub can also compute a replacement string with a block
    # Match the first letter of each word and capitalize it
    "hello world".gsub(/\b./) {|match| match.upcase } # => "Hello World"

    s.swapcase # => "wORLD": alter case of each letter

    s = "hello\r\n" # A string with a line terminator
    s.chomp! # => "hello": remove one line terminator from end
    s.chomp # => "hello": no line terminator so no change
    s.chomp! # => nil: return of nil indicates no change made
    s.chomp("o") # => "hell": remove "o" from end
    $/ = ";" # Set global record separator $/ to semicolon
    "hello;".chomp # => "hello": now chomp removes semicolons and end

    # chop removes trailing character or line terminator (\n, \r, or \r\n)
    s = "hello\r\n"
    s.chop! # => "hello": line terminator removed. s modified.

    # Strip all whitespace (including \t, \r, \n) from left, right, or both
    # strip!, lstrip! and rstrip! modify the string in place.
    s = "\t hello \n" # Whitespace at beginning and end
    s.strip # => "hello"
    s.lstrip # => "hello \n"
    s.rstrip # => "\t hello"

    # Left-justify, right-justify, or center a string in a field n-characters wide.
    # There are no mutator versions of these methods. See also printf method.
    s = "x"
    s.ljust(3) # => "x "
    s.rjust(3) # => " x"
    s.center(3) # => " x "
    s.center(5, '-') # => "--x--": padding other than space are allowed
    s.center(7, '-=') # => "-=-x-=-": multicharacter padding allowed " "

- - -

Strings may be enumerated byte-by-byte or line-by-line with the each_byte and
each_line iterators. In Ruby 1.8, the each method is a synonym for each_line, and the
String class includes Enumerable. Avoid using each and its related iterators because
Ruby 1.9 removes the each method and no longer makes strings Enumerable. Ruby 1.9
(and the jcode library in Ruby 1.8) adds an each_char iterator and enables characterby-
character enumeration of strings.

+ Ruby1.8 `each <=> each_line`, `each_byte`
+ Ruby1.9 added `each_char`

        # In Ruby 1.9, bytes, lines, and chars are aliases
        s.bytes.to_a # => [65,10,66]: alias for each_byte
        s.lines.to_a # => ["A\n","B"]: alias for each_line
        s.chars.to_a # => ["A", "\n", "B"] alias for each_char

- - -

    "10".to_i # => 10: convert string to integer
    "10".to_i(2) # => 2: argument is radix: between base-2 and base-36
    "10".to_i(8) # => 8
    "10".oct     # => 8
    '10'.to_i(16) # => 16
    '10'.hex     # => 16

    10.to_i(8)   # => Exception
    10.to_i(16)  # => Exception

    "one".to_sym # => :one -- string to symbol conversion
    "two".intern # => :two -- intern is a synonym for to_sym

    # Increment a string:
    "a".succ # => "b": the successor of "a". Also, succ!
    "aaz".next # => "aba": next is a synonym. Also, next!
    "a".upto("e") {|c| print c } # Prints "abcde. upto iterator based on succ.

    # Debugging
    "hello\n".dump # => "\"hello\\n\"": Escape special characters
    "hello\n".inspect # Works much like dump

    # Translation from one set of characters to another
    "hello".tr("aeiou", "AEIOU") # => "hEllO": capitalize vowels. Also tr!
    "hello".tr("aeiou", " ") # => "h ll ": convert vowels to spaces ")
    "bead".tr("aeiou", ' ')   # => "b  d"
    "bead".tr_s("aeiou", " ") # => "b d": convert and remove duplicates

    # Checksums
    "hello".sum         # => 532: weak 16-bit checksum
    "hello".sum(8)      # => 20: 8 bit checksum instead of 16 bit
    "hello".crypt("ab") # => "abl0JrMf6tlhw": one way cryptographic checksum
                        # Pass two alphanumeric characters as "salt"
                        # The result may be platform-dependent

    # Counting letters, deleting letters, and removing duplicates
    "hello".count('aeiou') # => 2: count lowercase vowels
    "hello".delete('aeiou') # => "hll": delete lowercase vowels. Also delete!
    "hello".squeeze('a-z') # => "helo": remove runs of letters. Also squeeze!
    # When there is more than one argument, take the intersection.
    # Arguments that begin with ^ are negated.
    "hello".count('a-z', '^aeiou') # => 3: count lowercase consonants
    "hello".delete('a-z', '^aeiou') # => "eo: delete lowercase consonants"

- - -

== Formatting Text

the **String** class defines a format operator **%**, and the **Kernel** module defines global **printf** and **sprintf** methods.

+ One advantage of printf-style formatting over regular string literal interpolation is that it allows precise control over field widths, which makes it useful for ASCII report generation. 
+ Another advantage is that it allows you to specify the number of significant digits to display in floating-point numbers, which is useful in scientific (and sometimes financial) applications. 
+ Finally, printf-style formatting decouples the values to be formatted from the string into which they are interpolated. This can be helpful for internationalization and localization of applications.

        # Alternatives to the interpolation above
        printf('%d blind %s', n+1, animal) # Prints '3 blind mice', returns nil
        sprintf('%d blind %s', n+1, animal) # => '3 blind mice'
        '%d blind %s' % [n+1, animal] # Use array on right if more than one argument

        # Formatting numbers
        '%d' % 10 # => '10': %d for decimal integers
        '%x' % 10 # => 'a': hexadecimal integers
        '%X' % 10 # => 'A': uppercase hexadecimal integers
        '%o' % 10 # => '12': octal integers
        '%f' % 1234.567 # => '1234.567000': full-length floating-point numbers
        '%e' % 1234.567 # => '1.234567e+03': force exponential notation
        '%E' % 1234.567 # => '1.234567e+03': exponential with uppercase E
        '%g' % 1234.567 # => '1234.57': six significant digits
        '%g' % 1.23456E12 # => '1.23456e+12': Use %f or %e depending on magnitude

        # Field width
        '%5s' % '<<<' # ' <<<': right-justify in field five characters wide
        '%-5s' % '>>>' # '>>> ': left-justify in field five characters wide
        '%5d' % 123 # ' 123': field is five characters wide
        '%05d' % 123 # '00123': pad with zeros in field five characters wide

        # Precision
        '%.2f' % 123.456 # '123.46': two digits after decimal place
        '%.2e' % 123.456 # '1.23e+02': two digits after decimal = three significant digits
        '%.6e' % 123.456 # '1.234560e+02': note added zero
        '%.4g' % 123.456 # '123.5': four significant digits

        # Field and precision combined
        '%6.4g' % 123.456 # ' 123.5': four significant digits in field six chars wide
        '%3s' % 'ruby' # 'ruby': string argument exceeds field width
        '%3.3s' % 'ruby' # 'rub': precision forces truncation of string

        # Multiple arguments to be formatted
        args = ['Syntax Error', 'test.rb', 20] # An array of arguments
        "%s: in '%s' line %d" % args # => "Syntax Error: in 'test.rb' line 20"
        # Same args, interpolated in different order! Good for internationalization.
        "%2$s:%3$d: %1$s" % args # => "test.rb:20: Syntax Error"

- - -

**Array.pack** and **String.unpack**, can be helpful if you are working with binary file formats
or binary network protocols. Use Array.pack to encode the elements of an array into a
binary string. And use String.unpack to decode a binary string.
