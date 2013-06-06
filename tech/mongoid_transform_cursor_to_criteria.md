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
