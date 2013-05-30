## content_for(name, content = nil, &block)

Calling content_for **stores a block of markup in an identifier for later use**. You can make subsequent calls to the stored content in other templates, helper modules or the layout by passing the identifier as an argument to content_for.

Note: **yield** can still be used to retrieve the stored content, but calling yield doesn’t work in helper modules, while content_for does.

WARNING: content_for is ignored in caches. So you shouldn’t use it for elements that will be fragment cached.

```ruby
<% content_for :not_authorized do %>
  alert('You are not authorized to do that!')
<% end %>

# two equal way to call
<%= content_for :not_authorized if current_user.nil? %>
<%= yield :not_authorized if current_user.nil? %>

# render both in order
<% content_for :navigation do %>
  <li><%= link_to 'Home', :action => 'index' %></li>
<% end %>

<%#  Add some other content, or use a different template: %>

<% content_for :navigation do %>
  <li><%= link_to 'Login', :action => 'login' %></li>
<% end %>
```

## content_tag(name, content = nil, options = nil, &block)

```ruby
content_tag(:p, "Hello world!")
 # => <p>Hello world!</p>
content_tag(:div, content_tag(:p, "Hello world!"), :class => "strong")
 # => <div class="strong"><p>Hello world!</p></div>
content_tag("select", options, :multiple => true)
 # => <select multiple="multiple">...options...</select>

<%= content_tag :div, :class => "strong" do -%>
  Hello world!
<% end -%>
 # => <div class="strong">Hello world!</div>
 
# this if is cool!
content_tag(:div, "Hello World", :class => ("active" if i_am_an_active_item?))

arr = ['a','b','c']
content_tag :div do 
  arr.collect { |letter| content_tag(:scan, letter) 
end
#=> <div>
#      <scan>a</scan>
#      <scan>b</scan>
#      <scan>c</scan>
#   </div>
```

## tag(name, options = nil, open = false, escape = true)

If you want to output an empty element (self-closed) like “br”, “img” or “input”, use the tag method instead.

```ruby
tag("br")
# => <br />

tag("br", nil, true)
# => <br>

tag("input", :type => 'text', :disabled => true)
# => <input type="text" disabled="disabled" />

tag("img", :src => "open & shut.png")
# => <img src="open & shut.png" />

tag("img", {:src => "open & shut.png"}, false, false)
# => <img src="open & shut.png" />
```
