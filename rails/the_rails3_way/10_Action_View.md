## Layouts and Templates

**Yielding Content**

The Ruby language’s built-in **yield** keyword is put to good use in making layout and
action templates collaborate.

```ruby
%body
  .left.sidebar
    = yield :left
  .content
    = yield
  .right.sidebar
    = yield :right

- content_for :left do
  %h2 Navigation
  %ul
    %li ...
- content_for :right do
  ...
```

**Conditional Output**

```ruby
- if show_subtitle?
  %h2= article.subtitle

%h2= article.subtitle if show_subtitle?

= "<h2>#{h(article.subtitle)}</h2>".html_safe if show_subtitle?

= content_tag('h2', article.subtitle) if show_subtitle?
```

**Standard Instance Variables**

```
# assigns
debug(assigns)

# controller
%body(class="#{controller.controller_name} #{controller.action_name}")

# cookies & session,  mostly used in controller not view
debug(cookies)
debug(session)
```

## Partials

**Passing Variables to Partials**

```ruby
render :partial => 'shared/entry', :locals => { :name => 'wendi' ... }

# shared/_entry.html.slim
h1
  "name: #{name}"
```

**Rendering Collections**

The objects being rendered are exposed to the partial template as a local variable named the same as the
partial template itself. In turn the template should be named according to the class of
the objects being rendered.

```ruby
render entries

# equaly
render :partial => 'entry', :collection => @entries

# _entry.html.haml
= div_for(entry) do
  = entry.description
  #{distance_of_time_in_words_to_now entry.created_at} ago
```

The **partial_counter** Variables

```ruby
= div_for(entry) do
  #{entry_counter}:#{entry.description}
  #{distance_of_time_in_words_to_now entry.created_at} ago
```
