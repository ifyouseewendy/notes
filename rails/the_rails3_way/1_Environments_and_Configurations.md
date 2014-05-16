## Bundler [ref](http://bundler.io)

Bundler does gem dependency resolution based on Gemfile.


1. The specifier **~>** has a special meaning, best shown by example. `~> 2.0.3` is identical to `>= 2.0.3` and `< 2.1`. `~> 2.1` is identical to `>= 2.1` and `< 3.0`. `~> 2.2.beta` will match prerelease versions like `2.2.beta.12`.

        gem 'thin',  '~>1.1'

2. Occasionally, the name of the gem that should be used in a require statement is
different than the name of that gem in the repository. In those cases, the **:require**
option solves this simply and declaratively right in the Gemfile.

        gem 'sqlite3-ruby', :require => 'sqlite3'

3. **group**

        gem 'wirble', :group => :development
        gem 'ruby-debug', :group => [:development, :test]

        group :test do
          gem 'rspec'
        end

4. **bundle install/update**

  	-> calculate a dependency tree -> generate Gemfile.lock

5. **bundle package**

  	> it will package up all your gems in **vendor/cache** directory. Running **bundle install** will use the gems in package and skip connecting to rubygems.org. use this to avoid external dependencies at deploy time, or if you depend on private gems that you are not available in any public repository.

6. **bundle exec**

  	Non-Rails scripts must be executed with this to get a properly initialized RubyGems environment.

7. **bundle install --path vender/bundle --binstubs**

  	The default location for gems installed by bundler is directory named **.bundle** in your user directory.

  	This command will generate .bundle/config file:

         ---
         BUNDLE_BIN: bundler_stubs
         BUNDLE_PATH: vendor/bundle
         BUNDLE_DISABLE_SHARED_GEMS: "1"

  	gems in **verdor/cache**, and installed in **vendor/bundle**.

8. **bundle install vendor --disable-shared-gems**

  	> This command tells Bundler to install gems even if they are already installed in the system. Normally Bunlder avoids that symlinks to already downloaded gems that exists in your system. This option is useful when you are trying to package up an application that all dependencies unpacked.


## Startup and Application Settings

`boot.rb`

  - sets up Bundler and load paths

`application.rb`

  - require 'boot'
  - load rails gems, gems for the specified Rail.env, and configures the application ( **define Application class** ).

`environment.rb`

  - require 'application'
  - runs all initializers ( `Application.initialize!` )

`environments/development.rb | test.rb | production.rb`

  - makes environmental configuraions.
  - application.rb makes unenvironmental configurations, like time-zone, autoload_paths, encoding.


#### Some Configurations

1. Wrap Parameters

	Introduced in Rails 3.1, the `wrap_parameters.rb` initializer configures your application to work with JavaScript MVC frameworks.

	When submitting JSON parameters to a controller, Rails will wrap the parameters into a nested hash, with the controller’s name being set as the key. To illustrate, consider the following JSON:


2. Schema Dumper

		config.active_record.schema_format = :sql

	Every time you run tests, Rails dumps the schema of your development database and copies it to the test database using an auto generated `schema.rb` script. It looks very similar to an Active Record migration script; in fact, it uses the same API.
	
3. Automatic Class Reloading

		config.cache_classes = false
		








6. Explain for Slow Queries

		config.active_record.auto_explain_threshold_in_seconds = 0.5
		
	Introduced in Rails 3.2, Active Record now monitors the threshold of SQL queries being made. If any query takes longer than the specified threshold, the query plan is logged with a warning.

	
7. Assets

		config.assets.debug = true
		
	Setting config.assets.debug to false, would result in Sprockets concatenating and running preprocessors on all assets.
	
		config.assets.compile = true

	If an asset is requested that does not exist in the public/assets folder, Rails will throw an exception. To enable live asset compilation fallback on production, set config.assets.compile to true.
	
		config.assets.enable = false
		
	Like most features in Rails, the usage of the Asset Pipeline is completely optional. To include assets in your project as it was done in Rails 3.0, set config.assets.enabled to false.
	
8. Tagged Logging [ref](http://arun.im/2011/x-request-id-tracking-taggedlogging-rails)

		config.log_tags = [ :subdomain, :uuid ]
		
	Rails 3.2 introduced the ability to tag your log messages. `:subdomain` example by *www*, `:uuid` is a string to identify request, try `request.uuid`.