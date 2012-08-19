# 1. Class Reloading

    config.cache_classes = false # IN DEVELOPMENT

    config.cache_classes = true  # IN TEST/PRODUCTION

when set true, Rails will use 'require' statement to do its class loading, when it is false, it will use 'load' instead.


# 2. Startup and Application Settings

<1. boot.rb
        sets up Bundler and load paths
<2. application.rb
        load rails gems, gems for the specified Rail.env
        configures the application
<3. environment.rb
        runs all initializers

