##startup

```ruby
sudo mongod --master --journal --port 27017 --fork --logappend --oplogSize 10000 --logpath /home/deploy/db/log/dev_db.log --dbpath /home/deploy/database
```

##mongodump & mongorestore

```ruby
mongodump --host localhost --port 27017 --db ac_shard1 --collection app_counters --out /home/deploy/data/mongodump

mongodump --host localhost --port 27017 --db dc_shard1 --collection daily_counters --out /home/deploy/data/mongodump --query "{ \"date\": { \"\$gte\": \"2013-04-01\", \"\$lt\": \"2013-06-06\" } }" } }"


# BSON::ObjectId::from_time( Time.parse('2013-04-01') ) =>  BSON::ObjectId("51585d800000000000000000") )

mongodump --host localhost --port 27017 --db event_group_counter --out /home/deploy/data/mongodump --query "{ \"_id\": { \"\$gt\": ObjectId(\"51585d800000000000000000\") } }"
```

```ruby
# with mongod instance running
mongorestore --host localhost --port 27017 --db proj_development ~/db/tar_gz/event_counter

# without mongod running
mongorestore --host localhost --port 27018 --dbpath /home/deploy/database --journal ~/db/tar_gz/ekv

--journal:
  A sequential, binary transaction used to bring the database into a consistent state in the event of a hard shutdown.
  When enabled, MongoDB writes data first to the journal and then to the core data files. MongoDB commits to the journal within 100ms.

```

p.s. **mongodump/mongorestore** work with binary data, while **mongoexport/mongoimport** work with JSON.



