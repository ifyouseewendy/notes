### startup
- - -
```ruby
rails new project --database=mysql

# -T skip Test::Unit
rails new project -T

- - -

$ git init
$ bundle install
$ rvm --rvmrc --create 1.9.3@project
```

### test
- - -

```ruby
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'database_cleaner'
  gem 'email_spec'
end
```

**rspec-rails** [#](https://github.com/rspec/rspec-rails)

**factory_girl_rails** [#](https://github.com/thoughtbot/factory_girl_rails)

**database_cleaner** [#](https://github.com/bmabey/database_cleaner)

```ruby
# spec/spec_helper.rb

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```


3. devise config

    ```ruby
    gem 'devise' # => Gemfile

    $ rails g devise:install # => config/initializers/devise.rb

    $ rails g devise User

    # add model field for database/token_authenticatable recoverable rememerable ..
    $ vim db/migrate/[data]_devise_create_users.rb

    $ rake db:migrate
    # this will generate db/schema.rb, which is used for rake db:setup
    # rake db:setup make migrations based on schema.rb, then seed with seeds.rb

    # seed the database
    $ vim db:seeds

    # rails g devise:views (default for all roles)
    $ rails g devise:views users

    # ---------------------------------------------------------------------
    # Configuration for devise:confirmable in ActionMailer (development.rb)
    #
    # # config.action_mailer.raise_delivery_errors = false
    # # ActionMailer Config
    # config.action_mailer.default_url_options = { :host => 'localhost:3000' }
    # # A dummy setup for development - no deliveries, but logged
    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.perform_deliveries = false
    # config.action_mailer.raise_delivery_errors = true
    # config.action_mailer.default :charset => "utf-8"
    #
    # ---------------------------------------------------------------------

    # ---------------------------------------------------------------------
    # Prevent Logging Passwords (application.rb)
    #
    # config.filter_parameters += [:password, :password_confirmation]
    # ---------------------------------------------------------------------

    # ---------------------------------------------------------------------
    # Filters and Helpers
    #
    # # inside Model
    # devise :database_authenticatable, :confirmable
    #
    # # inside Controller
    # before_filter :authenticate_user!
    #
    # # inside routes.rb
    # devise_for :users
    #
    # user_signed_in?
    # current_user
    # user_session
    # ---------------------------------------------------------------------

