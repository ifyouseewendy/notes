###\# Creating Migrations

usage:

```ruby
rails generate migration NAME [field:type field:type] [options]
```

**Sequencing Migrations**

Migrations that have already been run are listed in a special database table that Rails
maintains. It is named `schema_migrations` and only has one column.

When you pull down new migrations from source control, `rake db:migrate` will check
the `schema_migrations` table and execute all migrations that have not yet run (even if they have earlier timestamps than migrations that you’ve added yourself in the interim).

**Irreversible Migrations**

Some transformations are destructive in a manner that cannot be reversed. Migrations
of that kind should raise an `ActiveRecord::IrreversibleMigration` exception in
their down method.

For example, what if someone on your team made a silly mistake
and defined the telephone column of your clients table as an integer? You can change
the column to a string and the data will migrate cleanly, but going from a string to an
integer? Not so much.

```ruby
def self.up
  # Phone number fields are not integers, duh!
  change_column :clients, :phone, :string
end
def self.down
  raise ActiveRecord::IrreversibleMigration
end
```

> You can move the older migrations to
> a db/archived_migrations folder or something like that. Once you do trim the size
> of your migrations folder, use the rake db:reset task to (re)create your database from
> db/schema.rb and load the seeds into your current environment.

**Column Type Gotchas**

**:datetime and :timestamp** The Ruby class that Rails maps to datetime and
timestamp columns is Time. In 32-bit environments, Time doesn’t work for dates
before 1902. Ruby’s DateTime class does work with year values prior to 1902, and
Rails falls back to using it if necessary. It doesn’t use DateTime to begin for performance reasons. Under the covers, Time is implemented in C and is very fast, whereas
DateTime is written in pure Ruby and is comparatively slow.

**:integer and :string**  Rails developers leave off the size specification, which results in the default maximum sizes of 11 digits and 255 characters, respectively.

###\# schema.rb

The file `db/schema.rb` is generated every time you migrate and reflects the latest status of your database schema.

Note that this schema.rb definition is the authoritative source for your database
schema. If you need to create the application database on another system, you should
be using `db:schema:load`, not running all the migrations from scratch.

###\# Database Seeding

```ruby
User.delete_all
User.create!(:login => 'admin', ...

Client.delete_all
client = Client.create!(:name => 'Workbeast', ...
```

###\# Database-Related Rake Tasks

+ **db:create** and **db:drop**

  Create the database defined in config/database.yml for the current Rails.env.

+ **db:reset** and **db:setup**

  The db:setup creates the database for the current environment, loads the schema from
  db/schema.rb, then loads the seed data. It’s used when you’re setting up an existing
  project for the first time on a development workstation. The similar db:reset task does
  the same thing except that it drops and recreates the database first.

+ **db:schema:dump** and **db:schema:load**

  - Create a db/schema.rb file that can be portably used against any DB supported by Active Record.
  - Loads schema.rb file into the database for the current environment.

+ **db:seed**

  Load the seed data from db/seeds.rb as described in this chapter’s section Database
  Seeding.

+ **db:forward** and **db:backward**

  The db:rollback task moves your database schema back one version.

+ **db:migrate**

  - If a `VERSION` environment variable is provided, then db:migrate will apply pending migrations through the migration specified, but no further.
  - If the `VERSION` provided is older than the current version of the schema, then this task will actually rollback the newer migrations.

+ **db:migrate:up** and **db:migrate:down**

  - Invoked without a `VERSION`, this task will migrate all the way up/down the version list to an empty database
  - With a `VERSION`, this task will invoke the up/down method of the specified migration only.

+ **db:migrate:redo**

  Executes the down method of the latest migration file, immediately followed by its up
  method. This task is typically used right after correcting a mistake in the up method or
  to test that a migration is working correctly.

