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
