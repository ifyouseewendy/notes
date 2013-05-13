## The Basics

Active Record pattern maps one domain class to one database table, and one instance of
that class to each row of that database, the columns of that row
are represented as attributes of the object.

```ruby
my_project_development        database
User                          table   (users)
:name, :email                 column  (name, email)
user                          row
```

## Macro-Style Methods

== **Convention over Configuration**

It’s not that a newly bootstrapped Rails application comes with default configuration
in place already, reflecting the conventions that will be used. It’s that the **conventions
are baked into the framework**, actually hard-coded into its behavior, and you need to
override the default behavior with explicit configuration when applicable.

It’s also worth mentioning that most configuration happens in close proximity to
what you’re configuring. You will see associations, validations, and callback declarations
at the top of most Active Record models.

## Defining Attributes

The practical implication of the Active Record pattern is that you have to define
your database table structure and make sure it exists in the database prior to working
with your persistent models.

== **Serialized Attributes**

One of Active Record’s coolest features is the ability to mark a column of type `text` as
being serialized. Whatever object (more accurately, graph of objects) you assign to that
attribute will be stored in the database as YAML, Ruby’s native serialization format.

Why bother with the complexity of a separate preferences table if you can denormalize
that data into the users table instead?

```ruby
class User < ActiveRecord::Base
  serialize :preferences, Hash
end
```

## CRUD: Creating, Reading, Updating, Deleting

== **attributes** method

Note that the hash returned from
attributes is not a reference to an internal structure of the Active Record object. It is
copy, which means that changing its values will have no effect on the object it came from.

```
>> atts = first_client.attributes
=> {"name"=>"Paper Jam Printers", "code"=>"PJP", "id"=>1}
>> atts["name"] = "Def Jam Printers"
=> "Def Jam Printers"
>> first_client.attributes
=> {"name"=>"Paper Jam Printers", "code"=>"PJP", "id"=>1}
```

== **Accessing and Manipulating Attributes Before They Are Typecast**

The Active Record connection adapters, classes that implement behavior specific to
databases, fetch results as strings. Rails then takes care of converting them to other
datatypes if necessary, based on the type of the database column. For instance, integer
types are cast to instances of Ruby’s Fixnum class, and so on.

Sometimes you want to be able to read (or manipulate) the raw attribute data without
having the column-determined typecast run its course first, and that can be done by using
the **attribute_before_type_cast** accessors that are automatically created in your
model.

For example, consider the need to deal with currency strings typed in by your
end users. Unless you are encapsulating currency values in a currency class (highly
recommended, by the way) you need to deal with those pesky dollar signs and commas.
Assuming that our Timesheet model had a rate attribute defined as a :decimal type,
the following code would strip out the extraneous characters before typecasting for the
save operation:

```ruby
class Timesheet < ActiveRecord::Base
  before_validation :fix_rate

  def fix_rate
    self[:rate] = rate_before_type_cast.tr('$,','')
  end
end
```

== **Cloning**

Producing a copy of an Active Record object is done simply by calling clone, which
produces a shallow copy of that object. It is important to note that no associations will
get copied, even though they are stored internally as instance variables.

== **Custom SQL Queries**

prevent SQL injection

```ruby
>> Client.where("code like '#{params[:code]}%'")
=> [#<Client id: 1, name: "Amazon, Inc" ...>] # NOOOOO! params[:code] = "Amazon'; DELETE FROM users;'

>> param = "A"
>> Client.where("code like ?", "#{param}%")
=> [#<Client id: 1, name: "Amazon, Inc" ...>] # YES!
```

== **The Query Cache**

By default, Rails attempts to optimize performance by turning on a simple query cache.
It is a **hash stored on the current thread, one for every active database connection**. (Most
Rails processes will have just one.)

Whenever a **find** (or any other type of select operation) happens and the query
cache is active, the corresponding result set is stored in a hash with **the SQL that was
used to query for them as the key**. If the same SQL statement is used again in another
operation, the cached result set is used to generate a new set of model objects instead of
hitting the database again.

You can enable the query cache manually by wrapping operations in a **cache block**,
as in the following example:

```ruby
User.cache do
puts User.first
puts User.first
puts User.first
end

User Load (1.0ms) SELECT * FROM users LIMIT 1
CACHE (0.0ms) SELECT * FROM users LIMIT 1
CACHE (0.0ms) SELECT * FROM users LIMIT 1
```

Save and delete operations result in the cache being cleared, to prevent propagation
of instances with invalid states. If you find it necessary to do so for whatever reason, call
the **clear_query_cache** class method to clear out the query cache manually.

+ **Logging**

  The log file indicates when data is being read from the query cache instead of the database.
  Just look for lines starting with **CACHE** instead of a Model Load.

+ **Default Query Caching in Controllers**

  For performance reasons, Active Record’s query cache is **turned on by default** for the
  processing of controller actions.

+ **Limitations**

  The Active Record query cache was purposely kept very simple. Since it literally keys
  cached model instances on the SQL that was used to pull them out of the database, it
  *can’t connect multiple find invocations that are phrased differently but have the same
  semantic meaning and results*.

  For example, “select foo from bar where id = 1” and “select foo from bar where
  id = 1 limit 1” are considered different queries and will result in two distinct cache
  entries. The active record context plugin by Rick Olson is an example of a query cache
  implementation that is a little bit smarter about identity, since it keys cached results on
  primary keys rather than SQL statements.

== **Updating**

+ **update_all**

  ```ruby
  Project.update_all({:manager => 'Ron Campbell'}, :technology => 'Rails')

  Project.update_all("cost = cost * 3", "lower(technology) LIKE '%microsoft%'")
  ```

  - takes two parameters, the **set part of the SQL statement** and the **conditions**, expressed as part of a where clause.
  - returns the **number of records updated**.

+ **update** (id, attributes)

  - id - This should be the id or an array of ids to be updated.
  - attributes - This should be a hash of attributes or an array of hashes.


  ```ruby
  # Updates one record
  Person.update(15, :user_name => 'Samuel', :group => 'expert')

  # Updates multiple records
  people = { 1 => { "first_name" => "David" }, 2 => { "first_name" => "Jeremy" } }
  Person.update(people.keys, people.values)

  class ProjectController < ApplicationController
    def update
      Project.update(params[:id], params[:project])
      redirect_to projects_path
    end

    def mass_update
      Project.update(params[:projects].keys, params[:projects].values])
      redirect_to projects_path
    end
  end
  ```

  - the update class method does **invoke validation first** and will not save a record that fails validation. 
  - it returns the object whether or not the validation passes.
  - that means that if you want to know whether or not the validation passed, you need to follow up the call to update with a call to **valid?**

      ```ruby
      class ProjectController < ApplicationController
        def update
          project = Project.update(params[:id], params[:project])

          if project.valid? # uh-oh, do we want to run validate again?
            redirect_to project
          else
            render 'edit'
          end
        end
      end
      ```

      problem is that now we are calling valid? twice, since the update call also called it.
      Perhaps a better option is to use the **update_attributes** instance method.

+ **update_attributes(attributes, options = {})**

    - **validation**
    - takes a **hash of attribute** values
    - returns **true or false** depending on whether the save was successful or not, which is **dependent on validation** passing.

    ```ruby
    class ProjectController < ApplicationController
      def update
        project = Project.find(params[:id])

        if project.update_attributes(params[:project])
          redirect_to project
        else
          render 'edit'
        end
      end
    end
    ```


+ **update_attribute(name, value)**

  - takes a **key, value**
  - return **true or false** based on saving result

  ```ruby
  class StoryController < ApplicationController def points
    story = Story.find(params[:id])

    if story.update_attribute(:points, params[:value])
      render :text => "#{story.name} updated"
    else
      render :text => "Error updating story points"
    end
    end
  end
  ```

  - Validation is skipped
  - **Callbacks are invoked**
  - updated_at/updated_on column is **updated** if that column is available.

+ **update_column(name, value)**

  - Validation is skipped
  - **Callbacks are skipped**
  - updated_at/updated_on column is **not updated** if that column is available.

+ P.S. **save**

  - `save` with validation and callbacks
  - `save(:validate => false)` without validation, but with callbacks
  - `save!` with validation and callbacks, but no return true/false, raise exceptions (ActiveRecord::RecordInvalid)

== **Touching Records**

```ruby
>> user = User.first
>> user.touch #=> sets updated_at to now.
>> user.touch(:viewed_at) # sets viewed_at and updated_at to now.
```

If a **:touch** option is provided to a belongs to relation, it will touch the parent
record when the child is touched.

```ruby
class User < ActiveRecord::Base
  belongs_to :client, :touch => true
end

>> user.touch #=> also calls user.client.touch
```

== **Controlling Access to Attributes**

**Constructors and update methods that take hashes to do mass assignment** of attribute
values are susceptible to misuse by hackers when they are used in conjunction with the
params hash available in controller methods.

+ **attr_accessible**
+ **attr_protected**

    ```ruby
    class Customer < ActiveRecord::Base
      attr_protected :credit_rating
    end

    customer = Customer.new(:name => "Abe", :credit_rating => "Excellent")
    customer.credit_rating # => nil

    customer.attributes = { "credit_rating" => "Excellent" }
    customer.credit_rating # => nil }

    # and now, the allowed way to set a credit_rating
    customer.credit_rating = "Average"
    customer.credit_rating # => "Average"
    ```

== **Readonly Attributes**

```ruby
class Customer < ActiveRecord::Base
  attr_readonly :social_security_number
end

>> customer = Customer.new(:social_security_number => "130803020")
=> #<Customer id: 1, social_security_number: "130803020", ...>
>> customer.social_security_number
=> "130803020"
>> customer.save

>> customer.social_security_number = "000000000" # Note, no error raised!
>> customer.social_security_number
=> "000000000"

>> customer.save
>> customer.reload
>> customer.social_security_number
=> "130803020" # the original readonly value is preserved
```

The fact that trying to set a new value for a readonly attribute doesn’t raise an error
bothers my sensibilities, but I understand how it can make using this feature a little bit
less code-intensive.

You can get a list of all readonly attributes via the method **readonly_attributes**.

== **Deleting and Destroying**

+ The destroy method will both remove the object from the database and prevent
you from modifying it again:

    ```ruby
    >> bad_timesheet = Timesheet.find(1)
    >> bad_timesheet.destroy

    >> bad_timesheet.user_id = 2
    TypeError: can't modify frozen hash
    ```

    Note that calling save on an object that has been destroyed will fail silently. If you need
    to check whether an object has been destroyed, you can use the **destroyed?** method.

+ You can also call **destroy** and **delete** as class methods, passing the id(s) to delete.
Both variants accept a single parameter or array of ids:

    ```ruby
    Timesheet.delete(1)
    Timesheet.destroy([2, 3])
    ```

    - The **delete** method uses SQL directly and does not load any instances (hence it is faster).
    - The **destroy** method does load the instance of the Active Record object and then calls destroy on it as an instance method.
      The semantic differences are subtle, but come into play when you have assigned
      **before_destroy** callbacks or have **dependent associations**—child objects that should
      be deleted automatically along with their parent object.

## Database Locking

**Locking** is a term for techniques that prevent concurrent users of an application from
overwriting each other’s work. Active Record doesn’t normally use any type of database
locking when loading rows of model data from the database.

== **Optimistic Locking**

Optimistic locking describes the strategy of detecting and resolving collisions if they
occur, and is commonly recommended in multi-user situations where collisions should
be infrequent. Database records are never actually locked in optimistic locking, making
it a bit of a misnomer.

Optimistic locking is a fairly common strategy, because so many applications are
designed such that a particular user will mostly be updating with data that conceptually
belongs to him and not other users, making it rare that two users would compete for
updating the same record. The idea behind optimistic locking is that because collisions
should occur infrequently, we’ll simply deal with them only if they happen.

+ **Implementation** is add an integer column named **lock_version** to a given table, with a default value
of zero.

    ```ruby
    class AddLockVersionToTimesheets < ActiveRecord::Migration
      def self.up
        add_column :timesheets, :lock_version, :integer, :default => 0
      end

      def self.down
        remove_column :timesheets, :lock_version
      end
    end
    ```

    Now if the same record is loaded as two different model instances and saved differently,
    the first instance will win the update, and the second one will cause an
    **ActiveRecord::StaleObjectError** to be raised.

    ```ruby
    describe Timesheet do
      it "should lock optimistically" do
        t1 = Timesheet.create
        t2 = Timesheet.find(t1.id)

        t1.rate = 250
        t2.rate = 175

        t1.save.should be_true
        expect { t2.save }.to raise_error(ActiveRecord::StaleObjectError)
      end
    end
    ```
    Note that the **save** method (without
    the bang) returns false and does not raise exceptions if the save fails due to validation,
    but other problems such as locking in this case, can indeed cause it to raise exceptions.


    ```ruby
    # config/application.rb
    config.active_record.set_locking_column = 'alternate_lock_version'

    class Timesheet < ActiveRecord::Base
      set_locking_column 'alternate_lock_version'
    end
    ```

+ **Handling StaleObjectError**.

    Depending on the criticality of the data being updated, you might want to invest
    time into crafting a user-friendly solution that somehow preserves the changes that the
    loser was trying to make. At minimum, if the data for the update is easily re-creatable,
    let the user know why their update failed with controller code that looks something like
    the following:

    ```ruby
    def update
      timesheet = Timesheet.find(params[:id])
      timesheet.update_attributes(params[:timesheet])
      # redirect somewhere
    rescue ActiveRecord::StaleObjectError
      flash[:error] = "Timesheet was modified while you were editing it."
      redirect_to [:edit, timesheet]
    end
    ```
+ **merit and demerit**

    - **advantages** to optimistic locking. It doesn’t require any special feature
    in the database, and it is fairly easy to implement.

    - **disadvantages** to optimistic locking are that update operations are a bit
    slower because the lock version must be checked, and the potential for bad user experience,
    since they don’t find out about the failure until after they’ve potentially lost data.

== **Pessimistic Locking**

Pessimistic locking requires special database support (built into the major databases) and
locks down specific database rows during an update operation. It prevents another user
from reading data that is about to be updated, in order to prevent them from working
with stale data.

Pessimistic locking **works in conjunction with transactions** as in the following example:

```ruby
Timesheet.transaction do
  t = Timesheet.lock.first
  t.approved = true
  t.save!
end
```

It’s also possible to call **lock!** on an existing model instance, which simply calls
**reload(:lock => true)** under the covers. You wouldn’t want to do that on an instance
with attribute changes since it would cause them to be discarded by the reload.
If you decide you don’t want the lock anymore, you can pass **false** to the **lock!**
method.

Pessimistic locking takes place at the **database level**. The SELECT statement generated
by Active Record will have a FOR UPDATE (or similar) clause added to it, causing all other
connections to be blocked from access to the rows returned by the select statement. The
lock is released once the transaction is committed. There are theoretically situations
(Rails process goes boom mid-transaction?!) where the lock would not be released until
the connection is terminated or times out.

## Where Clauses

== **where(*conditions)**

The conditions parameter can be specified as a string or a hash. Parameters are
automatically santized to prevent SQL-injection attacks.

The hash notation is smart enough to create an IN clause if you associate an array of
values with a particular key.

```ruby
Product.where(:sku => [9400,9500,9900])
```

```ruby
Product.where('description like ? and color = ?', "%#{terms}%", color)
Product.where('sku in (?)', selected_skus)
```

bind variables

```ruby
Message.where("subject LIKE :foo OR body LIKE :foo", :foo => '%woah%')
```

It’s particularly important to take care in specifying conditions that include **boolean
values**. Databases have various different ways of representing boolean values in columns.
Rails will transparently handle the data conversion issues for
you if you pass a Ruby boolean object as your parameter:

```ruby
Timesheet.where('submitted = ?', true)
```

Using a question mark doesn’t let Rails figure out that a **nil** supplied as the value
of a condition should probably be translated into **IS NULL** in the resulting SQL query.

```ruby
# The first example does not work as intended, but the second one does work
>> User.where('email = ?', nil)
User Load (151.4ms) SELECT * FROM users WHERE (email = NULL)

>> User.where(:email => nil)
User Load (15.2ms) SELECT * FROM users WHERE (users.email IS NULL)
```

## Connections to Multiple Databases in Different Models

+ Connections are created via **ActiveRecord::Base.establish_connection** and
retrieved by **ActiveRecord::Base.connection**.

  All classes inheriting from **ActiveRecord::Base** will use this connection.

+ What if you want some of your models to use a different connection?

    ```ruby
    class LegacyProjectBase < ActiveRecord::Base
      # you can also use establish_connection "legacy_#{Rails.env}"
      establish_connection :legacy_database
      self.abstract_class = true
      ...
    end
    ```

    Incidentally, to make this example work with subclasses, you must specify
    **self.abstract_class = true** in the class context. Otherwise, Rails considers the
    subclasses of LegacyProject to be using single-table inheritance (STI)

    The **establish_connection** method takes a string (or symbol) key pointing to a
    configuration already defined in **database.yml**.

    ```ruby
    class TempProject < ActiveRecord::Base
      establish_connection :adapter => 'sqlite3', :database => ':memory:'
      ...
    end
    ```

+ Rails keeps database connections in a connection pool inside the `ActiveRecord::
Base` **class instance**. The connection pool is simply a Hash object indexed
by Active Record class. During execution, when a connection is needed, the
**retrieve_connection** method walks up the class-hierarchy until a matching connection
is found.

## Using the Database Connection Directly

It is possible to use Active Record’s underlying database connections directly, and sometimes
it is useful to do so from custom scripts and for one-off or ad-hoc testing. Access the
connection via the **connection** attribute of any Active Record class. If all your models
use the same connection, then use the connection attribute of ActiveRecord::Base.

```ruby
ActiveRecord::Base.connection.execute("show tables").all_hashes

def execute_sql_file(path)
  File.read(path).split(';').each do |sql|
    begin
      ActiveRecord::Base.connection.execute(#{sql}\n") unless sql.blank?
    rescue ActiveRecord::StatementInvalid
      $stderr.puts "warning: #{$!}"
    end
  end
end
```

The most basic operation that you can do with a connection is simply to execute a SQL
statement from the **DatabaseStatements** module.

The **ActiveRecord::ConnectionAdapters::DatabaseStatements** module mixes
a number of useful methods into the connection object that make it possible to work
with the database directly instead of using Active Record models.


