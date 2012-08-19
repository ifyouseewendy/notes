# 1. Rack

Rack is a modular interface for handling web requests. It abstracts away the handling HTTP requests and response into a single, simple 'call' method.

eg. HelloWorld as a Rack application

    class HelloWorld
      def call(env)
        [200, {"Content-Type" => "text/plain"}, ["Hello world!"]]
      end
    end

Classes that satisfy Rack's call interface can be chained together as filters, Rack itself includes a number of useful filter classes that do things such as logging and exception handling.

see which Rack filters are enabled for your Rails 3 application

    $ rake middleware

  when seeing use ActiveRecord::QueryCache, wondered what does it has to do with serving requests anyway?

    module ActiveRecord
      class QueryCache
        ...
        def call(env)
          ActiveRecord::Base.cache do
            @app.call(env)
          end
        end
      end
    end

  Active Record query caching does not have anything specially to do with serving requests. It's that Rails 3 is designed in such a way that different aspects of its behavior are introduced into that request call chain as individual Rack middleware components or filters.

## how to configure the middleware?

    # application.rb

    config.middleware.use Rack::Showstatus
    config.middleware.use(new_middleware, args)


# 2. Action Dispatch

Action Dispatch contains classes that interface the rest of the controller system to Rack.
