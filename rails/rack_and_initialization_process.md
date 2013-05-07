## [The Rails Initialization Process](http://railscasts-china.com/episodes/the-rails-initialization-process-by-kenshin54)

### \# rack

* rack 是一个规范，借口，规定 rack app 应该是一个包含 call 方法的ruby对象，它有且仅有一个参数 environment，返回一个数据[ status, header, body ]
* rack 用来解耦 web server 和 web framework
* rack middleware 是一个拦截器，可以用来组成 middleware chain

```ruby
# finder.ru

run Rack::Directory.new("~/")

# rackup finder.ru
```
