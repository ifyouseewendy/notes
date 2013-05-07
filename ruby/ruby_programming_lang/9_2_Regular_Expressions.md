###\# Regexp Literals

Regular expression **modifier characters**:

    i # Ignore case when matching text.
    m # The pattern is to be matched against multiline text, so treat newline as an ordinary character: allow . to match newlines.
    x # Extended syntax: allow whitespace and comments in regexp.
    o # Perform #{} interpolations only once, the first time the regexp literal is evaluated.
    u,e,s,n # Interpret the regexp as Unicode (UTF-8), EUC, SJIS, or ASCII. If none of these modifiers is specified, the regular expression is assumed to use the source encoding.

    "\n " =~ /./  # 1
    "\n " =~ /./m # 0 In multiline mode, . matches newline, too

    [1,2].map{|x| /#{x}/} # => [/1/, /2/]
    [1,2].map{|x| /#{x}/o} # => [/1/, /1/]

Ruby allows you to begin your regular expressions with **%r** followed by a delimiter of your choice. This is useful when the pattern you are describing contains a lot of forward slash characters that you don’t want to escape.

    %r|/| # Matches a single slash character, no escape required
    %r[</(.*)>]i # Flag characters are allowed with this syntax, too

Regexp literals allow the **interpolation** of arbitrary Ruby expressions with the **#{}** syntax.

    prefix = ","
    /#{prefix}\t/ # Matches a comma followed by an ASCII TAB character

- - -

###\# Regexp Factory Methods

    Regexp.new("Ruby?") # /Ruby?/
    Regexp.new("ruby?", Regexp::IGNORECASE) # /ruby?/i
    Regexp.compile(".", Regexp::MULTILINE, "u") # /./mu

    pattern = "[a-z]+" # One or more letters
    suffix = Regexp.escape("()") # Treat these characters literally
    r = Regexp.new(pattern + suffix) # /[a-z]+\(\)/

In Ruby 1.9, the factory method **Regexp.union** creates a pattern that is the “union” of
any number of strings or Regexp objects. Strings passed to **Regexp.union** are automatically
escaped, unlike those passed to **new** and **compile**.

    # Match any one of five language names.
    pattern = Regexp.union("Ruby", "Perl", "Python", /Java(Script)?/)
    # Match empty parens, brackets, or braces. Escaping is automatic:
    Regexp.union("()", "[]", "{}") # => /\(\)|\[\]|\{\}/

###\# Regular Expression Syntax

    # Special character classes
    /./ # Match any character except newline
    /./m # In multiline mode . matches newline, too
    /\d/ # Match a digit /[0-9]/
    /\D/ # Match a nondigit: /[^0-9]/
    /\s/ # Match a whitespace character: /[ \t\r\n\f]/
    /\S/ # Match nonwhitespace: /[^ \t\r\n\f]/
    /\w/ # Match a single word character: /[A-Za-z0-9_]/
    /\W/ # Match a nonword character: /[^A-Za-z0-9_]/

    # Nongreedy repetition: match the smallest number of repetitions
    /<.*>/  # Greedy repetition: matches "<ruby>perl>"
    /<.*?>/ # Nongreedy: matches "<ruby>" in "<ruby>perl>"
            # Also nongreedy: ??, +?, and {n,m}?

    # Backreferences: matching a previously matched group again
    /([Rr])uby&\1ails/  # Match ruby&rails or Ruby&Rails
    /(['"])[^\1]*\1/    # Single or double-quoted string
                        # \1 matches whatever the 1st group matched
                        # \2 matches whatever the 2nd group matched, etc.

    # Named groups and backreferences in Ruby 1.9: match a 4-letter palindrome
    /(?<first>\w)(?<second>\w)\k<second>\k<first>/
    /(?'first'\w)(?'second'\w)\k'second'\k'first'/ # Alternate syntax

    # Anchors: specifying match position
    /^Ruby/       # Match "Ruby" at the start of a string or internal line
    /Ruby$/       # Match "Ruby" at the end of a string or line
    /\ARuby/      # Match "Ruby" at the start of a string
    /Ruby\Z/      # Match "Ruby" at the end of a string
    /\bRuby\b/    # Match "Ruby" at a word boundary
    /\brub\B/     # \B is nonword boundary:
                  # match "rub" in "rube" and "ruby" but not alone
    /Ruby(?=!)/   # Match "Ruby", if followed by an exclamation point
    /Ruby(?!!)/   # Match "Ruby", if not followed by an exclamation point
    /hell(?=o)/   # Match 'hell' in 'hello'
    /hell(?!o)/   # Match nil in 'hello'

    # Special syntax with parentheses
    /R(?#comment)/ # Matches "R". All the rest is a comment
    /R(?i)uby/ # Case-insensitive while matching "uby"
    /R(?i:uby)/ # Same thing
    /rub(?:y|le))/ # Group only without creating \1 backreference

    # The x option allows comments and ignores whitespace
    / # This is not a Ruby comment. It is a literal part
      # of the regular expression, but is ignored.
      R       # Match a single letter R
      (uby)+  # Followed by one or more "uby"s
      \       # Use backslash for a nonignored space
    /x            # Closing delimiter. Don't forget the x option!

- - -

**Sequences, alternatives, groups, and references**

    ab                Matches expression a followed by expression b.
    a|b               Matches either expression a or expression b.

    (re)              Grouping: groups re into a single syntactic unit that can be used with *, +, ?, |, and so on. Also
                      “captures” the text that matches re for later use.
    (?:re)            Groups as with (), but does not capture the matched text.
    'hello'.match /(hel)lo/   => #<MatchData "hello" 1:"hel">
    'hello'.match /(?:hel)lo/ => #<MatchData "hello">

    (?<name>re)       Groups a subexpression and captures the text that matches re as with (), and also labels the
                      subexpression with name. Ruby 1.9.
    (?'name're)       A named capture, as above. Single quotes may optionally replace angle brackets around name. Ruby 1.9.

    \1...\9           Matches the same text that matched the nth grouped subexpression.
    \10...            Matches the same text that matched the nth grouped subexpression if there are that many previous
                      subexpressions. Otherwise, matches the character with the specified octal encoding.
    \k<name>          Matches the same text that matched the named capturing group name.

    # ???
    \g<n>             Matches group n again. n can be a group name or a group number. Contrast \g, which rematches or
                      reexecutes the specified group, with an ordinary back reference that tries to match the same text that
                      matched the first time. Ruby 1.9.

    Subexpression Calls ( Recursive execute group )

    The \g<name> syntax matches the previous subexpression named name, which can be a group name or number, again. 
    This differs from backreferences in that it re-executes the group rather than simply trying to re-match the same text.

    # Matches a <i>(</i> character and assigns it to the <tt>paren</tt>
    # group, tries to call that the <tt>paren</tt> sub-expression again
    # but fails, then matches a literal <i>)</i>.
    /\A(?<paren>\(\g<paren>*\))*\z/ =~ '()'

    /\A(?<paren>\(\g<paren>*\))*\z/ =~ '(())' #=> 0
    # ^1
    #      ^2
    #           ^3
    #                 ^4
    #      ^5
    #           ^6
    #                      ^7
    #                       ^8
    #                       ^9
    #                           ^10

    1. Matches at the beginning of the string, i.e. before the first character.

    2. Enters a named capture group called paren

    3. Matches a literal (, the first character in the string

    4. Calls the paren group again, i.e. recurses back to the second step

    5. Re-enters the paren group

    6. Matches a literal (, the second character in the string

    7. Try to call paren a third time, but fail because doing so would prevent an overall successful match

    8. Match a literal ), the third character in the string. Marks the end of the second recursive call

    9. Match a literal ), the fourth character in the string

    10. Match the end of the string

    /\A(?<paren>\(\g<paren>*\))*\z/ =~ '(()(())()())'

    This pattern is MAGICAL!!!

    # Another Example
    #
    # A fragment of C code need to remove /* */ like comment
    str = "include 'stdio.h'\n\nint main()\n{\n  int a=0; /* initialize */\n  /*\n  This function is for testing.\n  Usage:\n  int x = 1; /* hello world */\n  Done\n  */\n}\n"

    p = p = /((?<match>\/\*)\g<match>*.*\*\/)*/m

    str.gsub(p, '') # => "include 'stdio.h'\n\nint main()\n{\n  int a=0; \n}\n"

- - -

**Anchors**

    Anchors           Anchors do not match characters but instead match the zero-width positions between characters,
                      “anchoring” the match to a position at which a specific condition hol.
    ^                 Matches beginning of line.
    $                 Matches end of line.

    \A                Matches beginning of string.
    \Z                Matches end of string. If string ends with a newline, it matches just before newline.
    \z                Matches end of string.
                      "hello\n" =~ /hello\Z/ # => 0
                      "hello\n" =~ /hello\z/ # => nil

    \G                Matches point where last match finished, used in continuing matches.

    \b                Matches word boundaries when outside brackets. Matches backspace (0x08) when inside brackets.
    \B                Matches nonword boundaries.

    (?=re)            Positive lookahead assertion: ensures that the following characters match re, but doesn’t include
                      those characters in the matched text.
    (?!re)            Negative lookahead assertion: ensures that the following characters do not match re.
    (?<=re)           Positive lookbehind assertion: ensures that the preceeding characters match re, but doesn’t include
                      those characters in the matched text. Ruby 1.9.
    (?<!re)           Negative lookbehind assertion: ensures that the preceeding characters do not match re. Ruby 1.9.

- - -

**Miscellaneous**

    (?onflags-offflags)       Doesn’t match anything, but turns on the flags specified by onflags, and turns off the flags specified
                              by offflags. These two strings are combinations in any order of the modifier letters i, m, and x.
                              Flag settings specified in this way take effect at the point that they appear in the expression and persist
                              until the end of the expression, or until the end of the parenthesized group of which they are a part,
                              or until overridden by another flag setting expression.
    (?onflags-offflags:x)     Matches x, applying the specified flags to this subexpression only. This is a noncapturing group, like
                              (?:...), with the addition of flags.
    (?#...)                   Comment: all text within parentheses is ignored.
    (?>re)                    Matches re independently of the rest of the expression, without considering whether the match causes
                              the rest of the expression to fail to match. Useful to optimize certain complex regular expressions. The
                              parentheses do not capture the matched text.

- - -

###\# Pattern Matching with Regular Expression

* the global variable **$~** holds a **MatchData** object which contains complete information about the match.  
* $~ is a special **thread-local** and **method-local** variable. Two threads running concurrently
will see distinct values of this variable. And a method that uses the =~ operator
does not alter the value of $~ seen by the calling method.  
* Invoking `Regexp.last_match` method with no arguments returns the same value as a reference to $~.

        "hello" =~ /e\w{2}/ # 1: Match an e followed by 2 word characters
        Regexp.last_match   # #<MatchData "ell">
        $~                  # #<MatchData "ell">
        $~.string           # "hello": the complete string
        $~.to_s             # "ell": the portion that matched
        $~.pre_match        # "h": the portion before the match
        $~.post_match       # "o": the portion after the match

- - -

> **Named Captures** and Local Variables  
> In Ruby 1.9, if a regular expression containing named captures appears **literally** on the
> lefthand side of the =~ operator, then the names of the capturing groups are taken to
> be local variables, and the text that matches is assigned to those variables. If the match
> fails, then the variables are assigned nil.
>
> If a pattern is stored in a variable or a constant or is returned by a method,
> or if the pattern appears on the righthand side, then the =~ operator does not perform
> this special local variable assignment.

    # Ruby 1.9 only
    if /(?<lang>\w+) (?<ver>\d+\.(\d+)+) (?<review>\w+)/ =~ "Ruby 1.9 rules!"
      lang    # => "Ruby"
      ver     # => "1.9"
      review  # => "rules"
    end

- - -

Special global regular expression variables

    $~        $LAST_MATCH_INFO    Regexp.last_match
    $&        $MATCH              Regexp.last_match[0]
    $`        $PREMATCH           Regexp.last_match.pre_match
    $'        $POSTMATCH          Regexp.last_match.post_match
    $1        none                Regexp.last_match[1]
    $2, etc.  none                Regexp.last_match[2], etc.
    $+        $LAST_PAREN_MATCH   Regexp.last_match[-1]

- - -

Search and Replace

    text.gsub!(/\brails\b/, "Rails") # Capitalize the word "Rails" throughout
    text.gsub(/\bruby\b/i, '<b>\0</b>')

    # This does not work, however, because in this case the interpolation is performed on
    # the string literal before it is passed to gsub. This is before the pattern has been matched,
    # so variables like $& are undefined or hold values from a previous match.
    text.gsub(/\bruby\b/i, "<b>#{$&}</b>")

    # in Ruby 1.9, Strip pairs of quotes from a string
    re = /(?<quote>['"])(?<body>[^'"]*)\k<quote>/
    puts "These are 'quotes'".gsub(re, '\k<body>')

    pattern = /(['"])([^\1]*)\1/ # Single- or double-quoted string
    text.gsub!(pattern) do
      if ($1 == '"') # If it was a double-quoted string
        "'#$2'" # replace with single-quoted
      else # Otherwise, if single-quoted
        "\"#$2\"" # replace with double-quoted
      end
    end


