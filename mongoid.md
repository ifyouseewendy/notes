### How to make a no timeout query from MongoDB ?
- - -

* example1

    ```ruby
    # Mongoid.database[User.collection.name].find......
    db = Mongo::Connection.new('localhost',27017).db('application_development')
    db.collection("users").find({}, {:timeout => false}) do |cursor|
      puts cursor.class # => Mongo::Cursor
      cursor.each do |user|
        puts user.class # => BSON::OrderedHash
        # access user with string keys, like user["_id"], user["name"]

        make_some_op_on user
      end
    end
    ```

* example2: get no timeout query result ( *OrderedHash* ), wrap back to *Mongoid::Criteria*

    ```ruby
    def load_channels(app_id)
      # origin load method
      # App.where(:_id => app_id).first.channels.where(:enabled => true)

      # add :timeout => false
      channels = []
      Channel.collection.driver.find({"app_id" => BSON::ObjectId(app_id)}, {:timeout => false}) do |cursor|
        cursor.each do |channel|
          channels << Channel.new(channel)
        end
      end
      channels
    end
    ```

### How to transform from Mongo::Cursor to Mongoid::Criteria ?
- - -

* give cursor *OrderedHash* element to `criteria.selector` 

    ```ruby
    def load_channles(app_id)
      channels = []
      Channel.collection.driver.find({"app_id" => BSON::ObjectId(app_id)}, {:timeout => false}) do |cursor|
        cursor.each do |channel|
          criteria = Channel.criteria
          criteria.selector = channel
          channels << critieria.first # criteria.count always == 1
        end
      end
      channels
    end
    ```
