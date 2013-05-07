#### How to run rake tasks from within rake task?

* This always executes the task, but it does not executes its dependencies.

    ```ruby
    Rake::Task['build'].execute
    ```

* This one executes the dependencies, but it only executes the task if has not already been invoked.

    ```ruby
    Rake::Task['build'].invoke
    ```

* This first reset the task `already_invoked` state, allowing the task to then be executed again, including dependencies and all.

    ```ruby
    Rake::Task['build'].reenable
    Rake::Task['build'].invoke
    ```

* an example

    ```ruby
    namespace :wendi do

      desc 'outer task'
      task :foo do
        Rake::Task["wendi:bar"].reenable
        Rake::Task["wendi:bar"].invoke("hello", "world")
      end

      desc 'inner task'
      task :bar, [:arg1, :arg2] => :environment do |t, args|
        puts "hello world"
        puts "t is : #{t}"
        puts "args are : #{args}"
      end

      => hello world
      => t is : wendi:bar
      => args are : {:arg2=>"world", :arg1=>"hello"}

    end
    ```
