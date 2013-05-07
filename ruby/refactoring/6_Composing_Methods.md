#### 1. Extract Method
- - -

> Temporary variables often are so plentiful that they make extraction very
> awkward. In these cases I try to reduce the temps by using **Replace Temp with
> Query**. If whatever I do things are still awkward, I resort to **Replace Method
> with Method Object**. This refactoring doesn’t care how many temporaries you
> have or what you do with them.

case before:

    def print_owing
      outstanding = 0.0

      # print banner
      puts "*************************"
      puts "***** Customer Owes *****"
      puts "*************************"

      # calculate outstanding
      @orders.each do |order|
        outstanding += order.amount
      end

      # print details
      puts "name: #{@name}"
      puts "amount: #{outstanding}"
    end

case after:

    def print_owing
      print_banner
      outstanding = calculate_outstanding
      print_details outstanding
    end

    def print_banner
      # print banner
      puts "*************************"
      puts "***** Customer Owes *****"
      puts "*************************"
    end

    def calculate_outstanding
      @orders.inject(0.0) { |result, order| result += order.amount }
    end

    def print_details outstanding
      # print details
      puts "name: #{@name}"
      puts "amount: #{outstanding}"
    end

#### 2. Inline Method
- - -
#### 3. Inline Temp
- - -
#### 4. Replace Temp with Query
- - -

**Replace Temp with Query** often is a vital step before **Extract Method**. Local
variables make it difficult to extract, so replace as many variables as you can
with queries.

> The straightforward cases of this refactoring are those in which temps are
> assigned only to once and those in which the expression that generates the
> assignment is free of side effects. Other cases are trickier but possible. You may
> need to use **Split Temporary Variable** or **Separate Query from Modifier** first to
> make things easier. If the temp is used to collect a result (such as summing over
> a loop), you need to copy some logic into the query method.


case before:

    def price
      base_price = @quantity * @item_price

      if base_price > 1000
        discount_factor = 0.95
      else
        discount_factor = 0.98
      end

      base_price * discount_factor
    end

case after:

    def price
      base_price * discount_factor
    end

    def base_price
      @quantity * @item_price
    end

    def discount_factor
      base_price > 1000 ? 0.95 : 0.98
    end

#### 5. Replace Temp with Chain
- - -

Change the methods to support chaining, thus removing the need for a temp.

> At first glance, **Replace Temp With Chain** might seem to be in direct contrast
to **Hide Delegate**. The important difference is that Hide Delegate should be
used to hide the fact that an object of one type needs to delegate to an object
of another type. It is about encapsulation—the calling object should not reach
down through a series of subordinate objects to request information—it should
tell the nearest object to do a job for it. Replace Temp With Chain, on the other
hand, involves only one object. It’s about improving the fluency of one object by
allowing chaining of its method calls.

case before:

    class Select
      def options
        @options ||= []
      end

      def add_option(arg)
        options << arg
      end
    end

    select = Select.new
    select.add_option(1999)
    select.add_option(2000)
    select.add_option(2001)
    select.add_option(2002)
    select # => #<Select:0x28708 @options=[1999, 2000, 2001, 2002]>

case after:

    class Select
      def self.with_option(option)
        select = self.new
        select.options << option
        select
      end

      def options
        @options ||= []
      end

      def and(arg)
        options << arg
        self
      end
    end

    select = Select.with_option(1999).and(2000).and(2001).and(2002)

    select # => #<Select:0x28578 @options=[1999, 2000, 2001, 2002]>

#### 6. Introduce Explaining Variable
- - -

Put the result of the expression, or parts of the expression, in a temporary variable
with a name that explains the purpose.

    if (platform.upcase.index("MAC") &&
        browser.upcase.index("IE") &&
        initialized? &&
        resize > 0
       )
      # do something
    end

    # TURNS TO


    is_mac_os = platform.upcase.index("MAC")
    is_ie_browser = browser.upcase.index("IE")
    was_resized = resize > 0

    if (is_mac_os && is_ie_browser && initialized? && was_resized)
      # do something
    end

> Extraneous temporary variables are not a good thing:
> They can clutter method bodies and distract the reader, hindering their
> understanding of the code. So why do we introduce them? It turns out
> that in some circumstances, temporary variables can make code a little
> less ugly. But whenever I’m tempted to introduce a temporary variable,
> I ask myself if there’s another option. In the case of **Introduce Explaining
> Variable**, I almost always prefer to use **Extract Method** if I can. A
> temp can only be used within the context of one method. A method
> is useful throughout the object and to other objects. There are times,
> however, when other local variables make it difficult to use Extract
> Method. That’s when I bite the bullet and use a temp.

case

    def price
      # price is base price - quantity discount + shipping
      return @quantity * @item_price -
        [0, @quantity - 500].max * @item_price * 0.05 +
        [@quantity * @item_price * 0.1, 100.0].min
    end

refactored with **Introduce Explaining Variable**

    def price
      base_price = @quantity * @item_price
      quantity_discount = [0, @quantity - 500].max * @item_price * 0.05
      shipping = [base_price * 0.1, 100.0].min
      return base_price - quantity_discount + shipping
    end

refactored with **Extract Method**

    def price
      base_price - quantity_discount + shipping
    end

    def base_price
      @quantity * @item_price
    end

    def quantity_discount
      [0, @quantity - 500].max * @item_price * 0.05
    end

    def shipping
      [base_price * 0.1, 100.0].min
    end

#### 7. Split Temporary Variable
- - -

Any variable with more than one responsibility
should be replaced with a temp for each responsibility. Using a temp for two
different things is confusing for the reader.

    temp = 2 * (@height + @width)
    puts temp
    temp = @height * @width
    puts temp

#

    perimeter = 2 * (@height + @width)
    puts perimeter
    area = @height * @width
    puts area

#### 8. Remove Assignments to Parameters
- - -

First let me make sure we are clear on the phrase "**assigns to a parameter**."
If you pass an object named foo as a parameter to a method, assigning to the
parameter means to change foo to refer to a different object.
The reason I don’t like this comes down to lack of clarity and to confusion
between pass by value and pass by reference.

    def a_method(foo)
      foo.modify_in_some_way # that's OK
      foo = another_object # trouble and despair will follow you
    end

case

    def discount(input_val, quantity, year_to_date)
      input_val -= 2 if input_val > 50
      input_val -= 1 if quantity > 100nput_val -= 4 if year_to_date > 10000
      input_val
    end

#

    def discount(input_val, quantity, year_to_date)
      result = inputval
      result -= 2 if input_val > 50
      result -= 1 if quantity > 100
      result -= 4 if year_to_date > 10000
    result

#### 9. Replace Method with Method Object
- - -

You have a long method that uses local variables in such a way that you cannot
apply **Extract Method**.

**Turn the method into its own object** so that all the local variables become
instance variables on that object. You can then decompose the method into
other methods on the same object.

Applying **Replace Method with Method Object** turns all these local variables
into attributes on the method object. You can then use **Extract Method** on this
new object to create additional methods that break down the original method.

case

    class Account
      def gamma(input_val, quantity, year_to_date)
        inportant_value1 = (input_val * quantity) + delta
        important_value2 = (input_val * year_to_date) + 100
        if (year_to_date - important_value1) > 100
          important_value2 -= 20
        end
        important_value3 = important_value2 * 7
        # and so on.
        important_value3 - 2 * important_value1
      end
    end

refactored

    class Gamma
      attr_reader :account,
                  :input_val,
                  :quantity,
                  :year_to_date,
                  :important_value1,
                  :important_value2,
                  :important_value3

      def initialize(account, input_val_arg, quantity_arg, year_to_date_arg)
        @account = account
        @input_val = input_val_arg
        @quantity = quantity_arg
        @year_to_date = year_to_date_arg
      end

      def compute
        @inportant_value1 = (input_val * quantity) + @account.delta
        @important_value2 = (input_val * year_to_date) + 100
        if (year_to_date - important_value1) > 100
          @important_value2 -= 20
        end
        @important_value3 = important_value2 * 7
        # and so on.
        @important_value3 - 2 * important_value1
      end

    end

    class Account
      def gamma(input_val, quantity, year_to_date)
        Gamma.new(self, input_val, quantity, year_to_date).compute
      end
    end

Then apply **Extract Method** safely.

#### 10. Substitute Algorithm
- - -

Replace the body of the method with the new algorithm.

    def found_friends(people)
      friends = []
      people.each do |person|
        if(person == "Don")
          friends << "Don"
        end
        if(person == "John")
          friends << "John"
        end
        if(person == "Kent")
          friends << "Kent"
        end
      end
      return friends
    end

    def found_friends(people)
      people.select do |person|
        %w(Don John Kent).include? person
      end
    end

#### 11. Replace Loop with Collection Closure Method
- - -

Like Extract Method, but Extract by Closure

    managerOffices = []

    employees.each do |e|
      managerOffices << e.office if e.manager?
    end

#

    managerOffices = employees.select {|e| e.manager?}.
                               collect {|e| e.office}

#### 12. Extract Surrounding Method
- - -

You have two methods that contain nearly identical code. The variance is in the
middle of the method.

Extract the duplication into a method that accepts a block and yields back to
the caller to execute the unique code.

> It’s not hard to remove duplication when the offending code is at the top or bottom
> of a method: Just use **Extract Method** to move the duplication out of the
> way. But what happens when the unique code is in the middle of the method?
>
> Conveniently, Ruby’s blocks allow us to extract the surrounding duplication
> and have the extracted method yield back to the calling code to execute the
> unique logic. As well as removing duplication, this refactoring can be used to
> hide away infrastructure code (for example, code for iterating over a collection
> or connecting to an external service), so that the business logic becomes more
> prominent.

case1

    def charge(amount, credit_card_number)
      begin
        connection = CreditCardServer.connect(...)
        connection.send(amount, credit_card_number)
      rescue IOError => e
        Logger.log "Could not submit order #{@order_number} to the server: #{e}"
        return nil
      ensure
        connection.close
      end
    end

#

    def charge(amount, credit_card_number)
      connect do |connection|
        connection.send(amount, credit_card_number)
      end
    end

    def connect
      begin
        connection = CreditCardServer.connect(...)
        yield connection
      rescue IOError => e
        Logger.log "Could not submit order #{@order_number} to the server: #{e}"
        return nil
      ensure
        connection.close
      end
    end

case 2

    class Person
      attr_reader :mother, :children, :name

      def initialize(name, date_of_birth, date_of_death=nil, mother=nil)
        @name, @mother = name, mother,
        @date_of_birth, @date_of_death = date_of_birth, date_of_death
        @children = []
        @mother.add_child(self) if @mother
      end

      def add_child(child)
        @children << child
      end

      def number_of_living_descendants
        children.inject(0) do |count, child|
          count += 1 if child.alive?
          count + child.number_of_living_descendants
        end
      end

      def number_of_descendants_named(name)
        children.inject(0) do |count, child|
          count += 1 if child.name == name
          count + child.number_of_descendants_named(name)
        end
      end

      def alive?
        @date_of_death.nil?
      end
    end

refactored

    def number_of_living_descendants
      count_descendants_matching { |descendant| descendant.alive? }
    end

    def number_of_descendants_named(name)
      count_descendants_matching { |descendant| descendant.name == name }
    end

    protected

    def count_descendants_matching(&block)
      children.inject(0) do |count, child|
        count += 1 if yield child
        count + child.count_descendants_matching(&block)
      end
    end

#### 13. Introduce Class Annotation
- - -

You have a method whose implementation steps are so common that they can
safely be hidden away.

Declare the behavior by calling a class method from the class definition.

> The implementation of an attribute accessor is so easy to understand that it can be hidden
> away and replaced with a class annotation. But when the purpose
> of the code can be captured clearly in a declarative statement, Introduce Class
> Annotation can clarify the intention of your code.

case

    class SearchCriteria...

      def initialize(hash)
        @author_id = hash[:author_id]
        @publisher_id = hash[:publisher_id]
        @isbn = hash[:isbn]
      end

    end

refactored

    class SearchCriteria

      def self.hash_initializer(*attribute_names)
        define_method(:initialize) do |*args|
          data = args.first || {}
          attribute_names.each do |attribute_name|
            instance_variable_set "@#{attribute_name}", data[attribute_name]
          end
        end
      end

      hash_initializer :author_id, :publisher_id, :isbn
    end

refactored again by extract into module

    module CustomInitializers
      def hash_initializer(*attribute_names)
        define_method(:initialize) do |*args|
          data = args.first || {}
          attribute_names.each do |attribute_name|
            instance_variable_set "@#{attribute_name}", data[attribute_name]
          end
        end
      end
    end

    Class.send :include, CustomInitializers

    class SearchCriteria...
      hash_initializer :author_id, :publisher_id, :isbn
    end

#### 14. Introduce Named Parameter
- - -

Convert the parameter list into a Hash, and use the keys of the Hash as names
for the parameters.

It’s particularly useful for
optional parameters—parameters that are only used in some of the calls can be
extra hard to understand.

case: naming only the optional parameters

    #
    class Books...
      def self.find(selector, conditions="", *joins)
        sql = ["SELECT * FROM books"]
        joins.each do |join_table|
          sql << "LEFT OUTER JOIN #{join_table} ON"
          sql << "books.#{join_table.to_s.chap}_id"
          sql << " = #{join_table}.id"
        end
        sql << "WHERE #{conditions}" unless conditions.empty?
        sql << "LIMIT 1" if selector == :first

        connection.find(sql.join(" "))
      end

#

    #
    class Books...
      def self.find(selector, hash={} )
        hash[:joins] ||= []
        hash[:conditions] ||= ""

        sql = ["SELECT * FROM books"]
        hash[:joins] .each do |join_table|
          sql << "LEFT OUTER JOIN #{join_table} ON"
          sql << "books.#{join_table.to_s.chop}_id"
          sql << "= #{join_table}.id"
        end

        sql << "WHERE #{ hash[:conditions] }" unless hash[:conditions] .empty?
        sql << "LIMIT 1" if selector == :first

        connection.find(sql.join(" "))
      end

#### 15. Remove Named Parameter
- - -

Convert the named parameter Hash to a standard parameter list.

> Most of the time,
> Introduce Named Parameter added complexity is worth the increased readability on the calling
> side, but sometimes the receiver changes in such a way that the added complexity
> is no longer justified. Perhaps the number of parameters has reduced, or one
> of the optional parameters becomes required, so we remove the required parameter
> from the named parameter Hash. Or perhaps we perform Extract Method or
> Extract Class and take only one of the parameters with us. The newly created
> method or class might now be able to be named in such a way that the parameter
> is obvious. In these cases, you want to remove the named parameter.

    #
    Books.find
    Books.find(:selector => :all,
        :conditions => "authors.name = 'Jenny James'",
        :joins => [:authors])
    Books.find(:selector => :first,
        :conditions => "authors.name = 'JennyJames'",
        :joins => [:authors])

    class Books...
      def self.find(hash={})
        hash[:joins] ||= []
        hash[:conditions] ||= ""

        sql = ["SELECT * FROM books"]
        hash[:joins].each do |join_table|
          sql << "LEFT OUTER JOIN #{join_table}"
          sql << "ON books.#{join_table.to_s.chop}_id = #{join_table}.id"
        end
        sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].empty?
        sql << "LIMIT 1" if hash[:selector] == :first

        connection.find(sql.join(" "))
      end

#

    #
    def self.find( selector , hash={})
      hash[:joins] ||= []
      hash[:conditions] ||= ""

      sql = ["SELECT * FROM books"]
      hash[:joins].each do |join_table|
        sql << "LEFT OUTER JOIN #{join_table} ON"
        sql << "books.#{join_table.to_s.chop}_id = #{join_table}.id"
      end
      sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].empty?
      sql << "LIMIT 1" if selector == :first

      connection.find(sql.join(" "))
    end

    Books.find(:all, :conditions => "authors.name = 'Jenny James'",
        :joins =>[:authors])
    Books.find(:first, :conditions => "authors.name = 'Jenny James'",
        :joins =>[:authors])

#### 16. Remove Unused Default Parameter
- - -

> When required, default values are a good thing. But sometimes, as
code evolves over time, fewer and fewer callers require the default value, until finally
the default value is unused. Unused flexibility in software is a bad thing. Maintenance
of this flexibility takes time, allows opportunities for bugs, and makes refactoring more
difficult. Unused default parameters should be removed.

    def product_count_items(search_criteria=nil)
      criteria = search_criteria | @search_criteria
      ProductCountItem.find_all_by_criteria(criteria)
    end

#

    def product_count_items(search_criteria)
      ProductCountItem.find_all_by_criteria(search_criteria)
    end

#### 17. Dynamic Method Definition
- - -

The primary goal for Dynamic Method Definition is to more concisely
express the method definition in a readable and maintainable format.

case 1

    #
    def error
      self.state = :error
    end
    def failure
      self.state = :failure
    end
    def success
      self.state = :success
    end

#

    #
    class Post
      def self.states(*args)
        args.each do |arg|
          define_method arg do
            self.state = arg
          end
        end
      end

      states :failure, :error, :success
    end

case 2

    #
    class PostData
      def initialize(post_data)
        @post_data = post_data
      end

      def params
        @post_data[:params]
      end

      def session
        @post_data[:session]
      end
    end

#

    #
    class PostData
      def initialize(post_data)
        (class << self; self; end).class_eval do
          post_data.each_pair do |key, value|
            define_method key.to_sym do
              value
            end
          end
        end
      end
    end

    # OR

    class Hash
      def to_module
        hash = self
        Module.new do
          hash.each_pair do |key, value|
            define_method key do
              value
            end
          end
        end
      end
    end

    class PostData
      def initialize(post_data)
        self.extend post_data.to_module
      end
    end

#### 18. Replace Dynamic Receptor with Dynamic Method Definition
- - -

> Debugging classes that use method_missing can often be painful. At best you often
get a **NoMethodError** on an object that you didn’t expect, and at worst you get stack
level too deep (**SystemStackError**).
There are times that method_missing is required. If the object must support unexpected
method calls you may not be able to avoid the use of method_missing. However,
often you know how an object will be used and using Dynamic Method
Definition you can achieve the same behavior without relying on method_missing.

case: Dynamic Delegation Without **method_missing**

    class Decorator
      def initialize(subject)
        @subject = subject
      end

      def method_missing(sym, *args, &block)
        @subject.send sym, *args, &block
      end
    end

This solution does work, but it can be problematic when mistakes are made.
For example, calling a method that does not exist on the subject results in the
subject raising a NoMethodError. Since the method call is being called on the decorator
but the subject is raising the error, it may be painful to track down where the
problem resides.

These problems can be avoided entirely by using the available data to dynamically
define methods at runtime. The following example defines an instance
method on the decorator for each public method of the subject.

Using this technique any invalid method calls will be correctly reported as
**NoMethodErrors** on the decorator. Additionally, there’s no method_missing definition,
which should help avoid the stack level too deep problem entirely.

    #
    class Decorator
      def initialize(subject)
        subject.public_methods(false).each do |meth|
          (class << self; self; end).class_eval do
            define_method meth do |*args|
              subject.send meth, *args
            end
          end
        end
      end
    end

#### 19. Isolate Dynamic Receptor
- - -

Despite the added complexity, method_missing is a powerful tool that needs
to be used when the interface of a class cannot be predetermined. On those
occasions I like to use **Isolate Dynamic Receptor** to move the method_missing
behavior to a new class: a class whose sole responsibility is to handle the
method_missing cases.

> The **ActiveRecord::Base** (AR::B) class defines method_missing to handle dynamic find
messages. The implementation of method_missing allows you to send find messages
that use attributes of a class as limiting conditions for the results that will be
returned by the dynamic find messages. For example, given a `Person` subclass of
AR::B that has both a first name and a ssn attribute, it’s possible to send the messages
`Person.find_by_first_name, Person.find_by_ssn, and Person.find_by_first_name_and_ssn`.

> It’s possible, though not realistic, to dynamically define methods for all possible
combinations of the attributes of an AR::B subclass. Utilizing method_missing
is a good alternative. However, by defining method_missing on the AR::B class itself
the complexity of the class is increased significantly. AR::B would benefit from a
maintainability perspective if instead the dynamic finder logic were defined on
a class whose single responsibility was to handle dynamic find messages. For
example, the previous `Person` class could support find with the following syntax:
`Person.find.by_first_name, Person.find.by_ssn, or Person.find.by_first_name_and_ssn`.

> **Tips**: Very often it’s possible to know all valid method calls ahead of
time, in which case I prefer Replace Dynamic Receptor with Dynamic
Method Definition.

case

    #
    class Recorder
      instance_methods.each do |meth|
        undef_method meth unless meth =~ /^(__|inspect)/
      end

      def messages
        @messages ||= []
      end

      def method_missing(sym, *args)
        messages << [sym, args]
        self
      end

      def play_for(obj)
        messages.inject(obj) do |result, message|
          result.send message.first, *message.last
        end
      end

      def to_s
        messages.inject([]) do |result, message|
          result << "#{message.first}(args: #{message.last.inspect})"
        end.join(".")
      end
    end

    class CommandCenter
      def start(command_string)
        ...
        self
      end

      def stop(command_string)
        ...
        self
      end
    end

    recorder = Recorder.new
    recorder.start("LRMMMMRL")
    recorder.stop("LRMMMMRL")
    recorder.play_for(CommandCenter.new)

> As the behavior of **Recorder** grows it becomes harder to identify the messages
that are dynamically handled from those that are actually explicitly defined.
By design the functionality of **method_missing** should handle any unknown message,
but how do you know if you’ve broken something by adding an explicitly
defined method?

> The solution to this problem is to introduce an additional class that has the
single responsibility of handling the dynamic method calls. In this case we have
a class Recorder that handles recording unknown messages as well as playing
back the messages or printing them. To reduce complexity we will introduce the
**MesageCollector** class that handles the method_missing calls.

    #
    class MessageCollector
      instance_methods.each do |meth|
        undef_method meth unless meth =~ /^(__|inspect)/
      end

      def messages
        @messages ||= []
      end

      def method_missing(sym, *args)
        messages << [sym, args]
        self
      end
    end

    class Recorder
      def play_for(obj)
        @message_collector.messages.inject(obj) do |result, message|
          result.send message.first, *message.last
        end
      end

      def record
        @message_collector ||= MessageCollector.new
      end

      def to_s
        @message_collector.messages.inject([]) do |result, message|
          result << "#{message.first}(args: #{message.last.inspect})"
        end.join(".")
      end
    end

    recorder = Recorder.new
    recorder.record.start("LRMMMMRL")
    recorder.record.stop("LRMMMMRL")
    recorder.play_for(CommandCenter.new)

#### 20. Move Eval from Runtime to Parse Time
- - -

Move the use of eval from within the method definition to defining the method
itself.

> This refactoring can be helpful
when you determine that eval is a source of performance pain. The **Kernel#eval**
method can be the right solution in some cases, but it is almost always more
expensive (**in terms of performance**) than its alternatives. In the cases where **eval**
is necessary, it’s often better to move an eval call from runtime to parse time

> It’s also worth noting that evaluating the entire method definition allows you
to change the `define_method` to `def` in this example. **All current versions of Ruby
execute methods defined with def significantly faster than methods defined using
define_method**; therefore, this refactoring could yield benefits for multiple reasons.
Of course, you should always measure to ensure that you’ve actually refactored
in the right direction.

    # define methods use eval in its body, evals in runtime.
    class Person
      def self.attr_with_default(options)
        options.each_pair do |attribute, default_value|
          define_method attribute do
            eval "@#{attribute} ||= #{default_value}"
          end
        end
      end

      attr_with_default :emails => "[]",
                        :employee_number =>"EmployeeNumberGenerator.next"
    end

#

    # define_method can be substituted with def
    class Person
      def self.attr_with_default(options)
        options.each_pair do |attribute, default_value|
          eval "define_method #{attribute} do
                @#{attribute} ||= #{default_value}
                end"
        end
      end

      attr_with_default :emails => "[]",
                        :employee_number =>"EmployeeNumberGenerator.next"
    end
