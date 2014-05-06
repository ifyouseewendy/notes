## Startup and Application Settings

**boot.rb**

  - sets up Bundler and load paths

**application.rb**

  - require 'boot'
  - load rails gems, gems for the specified Rail.env, and configures the application ( **define Application class** ).

**environment.rb**

  - require 'application'
  - runs all initializers ( `Application.initialize!` )

**environments/development.rb | test.rb | production.rb**

  - makes environmental configuraions.
  - application.rb makes unenvironmental configurations, like time-zone, autoload_paths, encoding.


