# 1. Class Reloading

    config.cache_classes = false # IN DEVELOPMENT

    config.cache_classes = true  # IN TEST/PRODUCTION

when set true, Rails will use 'require' statement to do its class loading, when it is false, it will use 'load' instead.


---

# 1. Bundler

<1. `$ bundle install vendor --disable-shared-gems`

- this command tells Bundler to install gems even if they are already installed in the system. Normally Bunlder avoids that symlinks to already downloaded gems that exists in your system.
- this option is useful when you are trying to package up an application that all dependencies unpacked.

<2. `$ bundle install/update`

- -> calculate a dependency tree -> generate Gemfile.lock

<3. `$ bundle package`

- it will package up all your gems in vendor/cache directory. Running `$ bundle install` will use the gems in package and skip connecting to rubygems.org.
- use this to avoid external dependencies at deploy time, or if you depend on private gems that you are not available in any public repository.

<4. `$ bundle exec`

- Non-Rails scripts must be executed with this to get a properly initialized RubyGems environment.


# 2. Startup and Application Settings

<1. boot.rb
        -- sets up Bundler and load paths
<2. application.rb
        -- <1. load rails gems, gems for the specified Rail.env <2. **define Application class**
<3. environment.rb
        -- <1. runs all initializers <2. **Application.initialize!**
<4. environments/development.rb
                test.rb
                production.rb
        -- **Application.configure**

**memo**:
* application.rb makes unenvironmental configurations, like time-zone, autoload_paths, encoding.
* environments/* makes environmental configuraions.

