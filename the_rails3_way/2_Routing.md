The routing system in Rails is the system that examines the URL of an incoming request
and determines what action should be taken by the application.

Route will be used both as a template for matching URLs and as a blueprint for creating them.  
The routing system does two things:

+ it maps requests to controller action methods.
+ it enables the dynamic generation of URLs for you for use as arguments to methods like
**link_to** and **redirect_to**.

## routes.rb

```ruby
match 'products/:id' => 'products#show', :via => [:get, :post]

# purchase_url(:id => product.id)
match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase

# the redirect method returns a simple Rack endpoint
match '/foo', :to => redirect('/bar')
match '/google', :to => redirect('http://google.com')

# redirect can take a block, or accept an optional :status parameter
match "/api/v1/:api", :to =>
  redirect(:status => 302) {|params| "/api/v2/#{params[:api].pluralize}" }
```

If requesting a format that is not included as an option in **respond_to** rails will return 406 Not Acceptable status

```ruby
def show
@product = Product.find(params[:id])
  respond_to do |format|
    format.html
    format.xml { render :xml => @product.to_xml }
  end
end
```
You can use **format.any** to catch, just make sure to explicitly tell any what to do with the request,
otherwise, you'll get a **MissingTemplate** exception.

```ruby
def show
@product = Product.find(params[:id])
  respond_to do |format|
    format.html
    format.xml { render :xml => @product.to_xml }
    format.any
  end
end
```

**:to** is that its value is what’s referred to a a **Rack endpoint**. To illustrate,

```ruby
match "/hello", :to => proc {|env| [200, {}, ["Hello world"]] }

>> ReportsController.action(:index)
=> #<Proc:0x01e96cd0@...>

# This behavior means that adding a route that dispatches to a Sinatra3 application is
# super-easy. Just point :to => YourSinatraApp. The Sinatra application class itself is
# a Rack endpoint.
class HelloApp < Sinatra::Base
  get "/" do
    "Hello World!"
  end
end

Example::Application.routes.draw do
  match "/hello", :to => HelloApp
end
```
You can also trigger a branching on respond_to by setting the **Accept header** in the
request. When you do this, there’s no need to add the **.:format** part of the URL.

```ruby
wget http://localhost:3000/items/show/3 -O - --header="Accept:text/xml"
```

Segment key **:constraints**

```ruby
# seems like it would match "foo32bar". It doesn’t because Rails implicitly anchors it at both
# ends. In fact, as of this writing, adding explicit anchors ^ and $ causes exceptions to be raised.
match ':controller/show/:id' => :show, :constraints => {:id => /\d+/}

match 'records/:id' => "records#protected",
  :constraints => proc {|req| req.params[:id].to_i < 100 }

# left :subdomain and :referrer attribute
```

The **public folder** in the root of your app corresponds to the
**root-level** URL, and the public directory in a newly generated Rails app contains an
**index.html** file.

Actually, the web server will serve up the **static
content** without involving Rails(without routing triggering) at all, which is why cached content ends up under the
public directory.

## Route Globbing

```ruby
match 'items/q/*specs', :controller => "items", :action => "query"

def query
  @items = Item.all.where(Hash[*params[:specs].split("/")])
  if @items.empty?
    flash[:error] = "Can't find items with those properties"
  end
  render :action => "index"
end

```

## Named Routes

```ruby
match 'help' => 'help#index', :as => 'help'

link_to "Help", help_path
```

Furthermore, it doesn’t have to be the id value that the route generator inserts into the
URL. As alluded to a moment ago, you can override that value by defining a **to_param**
method in your model.

Let’s say you want the description of an item to appear in the URL for the auction
on that item. In the item.rb model file, you would override to_param; here, we’ll
override it so that it provides a **“munged” (stripped of punctuation and joined with
hyphens) version of the description**, courtesy of the **parameterize** method added to
strings in Active Support.

```ruby
def to_param
description.parameterize
end
```

Subsequently, the method call item_path(auction, item) will produce something like

```ruby
/auction/3/item/cello-bow
```

Of course, if you’re putting things like "cello-bow" in a path field called :id, you
will need to make provisions to dig the object out again. Blog applications that use this
technique to create **slugs** for use in permanent links often have a separate database column
to store the munged version of the title that serves as part of the path. That way, it’s
possible to do something like

```ruby
Item.find_by_munged_description(params[:id])
```

> **Why shouldn’t you use numeric IDs in your URLs**? First, your competitors can see just how
many auctions you create. Numeric consecutive IDs also allow people to write automated spiders
to steal your content. It’s a window into your database. And finally, words in URLs just look
better.

## Scoping Routing Rules

```ruby
match 'auctions/new' => 'auctions#new'
match 'auctions/edit/:id' => 'auctions#edit'
match 'auctions/pause/:id' => 'auctions#pause'

scope :path => 'acutions', :controller => :auctions do
  match 'new' => :new
  match 'edit/:id' => :edit
  match 'pause/:id' => :pause
end
```

```ruby
# IDENTICAL
scope :controller => :auctions do
scope :auctions do
# controller :auctions do

# path prefix
scope :path => '/auctions' do
scope '/auctions' do

# name prefix
scope :auctions, :as => 'admin' do
  match 'new' => :new, :as => 'new_auction'
end
# generate named route URL helper
admin_new_auction_url
```

**namespace** is a syntactic sugar that rolls up **module**, **name prefix**, and **path prefix** into one declaration.

```ruby
namespace :auctions, :controller => :auctions do
  match 'new' => :new
  match 'edit/:id' => :edit
  match 'pause/:id' => :pause
end
```

bundling constraints

```ruby
scope :controller => :auctions, :constraints => {:id => /\d+/} do
  match 'edit/:id' => :edit
  match 'pause/:id' => :pause
end

scope :path => '/auctions', :controller => :auctions do
  match 'new' => :new
  constraints :id => /\d+/ do
    match 'edit/:id' => :edit
    match 'pause/:id' => :pause
  end
end
```


