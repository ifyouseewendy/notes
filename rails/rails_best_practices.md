##\# Fat Model, Skinny Controller

##\# Scope It Out

```ruby
@tweets = Tweet.find(
    :all,
    :conditions => {:user_id => current_user.id},
    :order => 'created_at desc',
    :limit => 10
    )

@tweets = current_user.tweets.recent.limit(10)

# models/tweet.rb
scope :recent, order('created_at desc' )
```

```ruby
@trending = Topic.find(
    :all,
    :conditions => ["started_trending > ?", 1.day.ago],
    :order => 'mentions desc',
    :limit => 5
    )

@trending = Topic.trending(5)
@trending = Topic.trending

# models/topic
scope :trending, lambda { |num = nil| where('started_trending > ?', 1.day.ago ).
                                      order( 'mentions desc' ).
                                        limit(num) }
```

##\# Fantastic Filters

```ruby
class TweetsController < ApplicationController
  before_filter :get_tweet, :only => [:edit, :update, :destroy]

  def get_tweet
    @tweet = Tweet.find(params[:id])
  end
  def edit
    ...
  end
  def update
    ...
  end
  def destroy
    ...
  end
end
```

+ Don't put instance variables in private methods.
+ Keep parameters in actions

```ruby
class TweetsController < ApplicationController
  def edit
    @tweet = get_tweet ( params[:id])
  end
  def update
    @tweet = get_tweet ( params[:id])
  end
  def destroy
    @tweet = get_tweet( params[:id])
  end

  private
  def get_tweet (tweet_id)
    Tweet.find(tweet_id)
  end
end
```
