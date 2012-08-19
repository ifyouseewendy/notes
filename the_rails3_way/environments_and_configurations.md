# 1. Class Reloading

    config.cache_classes = false # IN DEVELOPMENT

    config.cache_classes = true  # IN TEST/PRODUCTION

when set true, Rails will use 'require' statement to do its class loading, when it is false, it will use 'load' instead.
