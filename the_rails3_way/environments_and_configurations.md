# 1. Class Reloading

    config.cache_classes = false # IN DEVELOPMENT

    config.cache_classes = true  # IN TEST/PRODUCTION

when set true, Rails will use 'require' statement to do its class loading, when it is false, it will use 'load' instead.


# 2. Startup and Application Settings

1. boot.rb
        -- sets up Bundler and load paths
2. application.rb
        -- <1. load rails gems, gems for the specified Rail.env <2. **define Application class**
3. environment.rb
        -- <1. runs all initializers <2. **Application.initialize!**
4. environments/development.rb
                test.rb
                production.rb
        -- **Application.configure**

**memo**:
* application.rb makes unenvironmental configurations, like time-zone, autoload_paths, encoding.
* environments/* makes environmental configuraions.
