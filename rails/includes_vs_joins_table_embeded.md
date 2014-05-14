`includes`


Eager load the included associations into memory. Fire two queries:

	SELECT "products".* FROM "products" ORDER BY name
    SELECT "categories".* FROM "categories" WHERE "categories"."id" IN (2, 1, 5, 4, 3)

`joins`

Sometimes,`includes` will load many redundant fields in association table, `joins` help to control what columns after `SELECT`.

 
*Reference*

[ruby - Rails :include vs. :joins - Stack Overflow](http://stackoverflow.com/questions/1208636/rails-include-vs-joins/10129946)

[#181 Include vs Joins - RailsCasts](http://railscasts.com/episodes/181-include-vs-joins?language=zh&view=asciicast)

[N+1 Benchmark Gist - IBM Developer Works](https://gist.github.com/ifyouseewendy/6d0feb90d76fb894814a)

- - - 

**Does query with `includes` and `joins` return the same count? **[gist](https://gist.github.com/ifyouseewendy/429544e5b8f49a347e95)

```
class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class BugTest < Minitest::Test
  def test_association_stuff
    post1 = Post.create!
    post2 = Post.create!

    post1.comments << Comment.create!
    post1.comments << Comment.create!
    post2.comments << Comment.create!
    post2.comments << Comment.create!
    post2.comments << Comment.create!

    assert_equal 2, Post.includes(:comments).find(post1.id, post2.id).count
    # => SELECT "posts".* FROM "posts" WHERE "posts"."id" IN (1, 2)
    # => SELECT "comments".* FROM "comments" WHERE "comments"."post_id" IN (1, 2)

    assert_equal 5, Post.joins(:comments).where(id: [post1.id, post2.id]).count
    # => SELECT COUNT(*) FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" WHERE "posts"."id" IN (1, 2)

  end
end

```

**Does `includes` work with Mongoid?** 

Check list:

+ [N+1 problem in mongoid - Stack Overflow](http://stackoverflow.com/questions/3912706/n1-problem-in-mongoid)

+ [Eager Loading - Mongoid Doc](http://mongoid.org/en/mongoid/docs/querying.html#queries)

By now ( *2014-05-08* ) the latest version *4.0.0.beta1* behaves much better than last stable version *3.1.6*, check the [gist](https://gist.github.com/ifyouseewendy/0069c0498274d2dd5a6d).

Run by mongoid *3.1.6*

size							| user      | system    | total     | real
------------------------------ | --------- | --------- | --------- | ---------
size:100, with n+1 problem  	| 0.050000  | 0.000000  | 0.050000  | (0.076395)
size:100, with :include  		| 0.040000  | 0.010000  | 0.050000  | (0.064299)
size:1000, with n+1 problem  	| 0.480000  | 0.060000  | 0.540000  | (0.677470)
size:1000, with :include  		| 0.420000  | 0.060000  | 0.480000  | (0.614896)
size:10000, with n+1 problem  	| 4.750000  | 0.600000  | 5.350000  | (6.690200)
size:10000, with :include  		| 4.170000  | 0.590000  | 4.760000  | (6.098166)

Run by mongoid *4.0.0.beta1*

size							| user      | system    | total     | real
------------------------------ | --------- | --------- | --------- | ---------
size:100, with n+1 problem  	| 0.050000  | 0.010000  | 0.060000  | (0.071098)
size:100, with :include  		| 0.000000  | 0.000000  | 0.000000  | (0.004677)
size:1000, with n+1 problem  	| 0.500000  | 0.070000  | 0.570000  | (0.705868)
size:1000, with :include  		| 0.020000  | 0.000000  | 0.020000  | (0.020115)
size:10000, with n+1 problem  	| 5.390000  | 0.630000  | 6.020000  | (7.434118)
size:10000, with :include  		| 0.210000  | 0.000000  | 0.210000  | (0.214703)


