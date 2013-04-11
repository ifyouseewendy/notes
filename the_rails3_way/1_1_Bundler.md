### Bundler

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

