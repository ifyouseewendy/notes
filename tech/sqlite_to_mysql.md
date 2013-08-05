+ `gemfile`

  ```ruby
  + 'yaml_db'
  + 'mysql'
  - 'mongoid'
  ```

+ `rake db:data:dump RAILS_ENV=development`

+ change `database.yml`

  ```ruby
  defaults: &defaults
  - adapter: sqlite3
  - encoding: uft-8
  - pool: 5
  - timeout: 5000
  + adapter: mysql2
  + encoding: utf8
  + username: wendi
  + password: wendi
  + host: 127.0.0.1
  + port: 3306
  ```

+ `rake db:setup RAILS_ENV=development`

+ `rake db:data:load RAILS_ENV=development`
