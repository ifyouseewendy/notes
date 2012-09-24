### Commands ###

    $ rails g rspec:install

    # list all spec commands
    $ rake -T spec

    $ rake spec
    # if exists config/database.yml, then execute rake db:test:prepare as a dependency

    # -fs output result in specdoc format
    # -p --profile enable profiling of examples with output of top 10 slowest examples
    # -b --backtrace enable full backtrace
    # -d --debug enable debugging
    $ rspec -fs foo_spec.rb
    $ rspec -p foo_spec.rb

