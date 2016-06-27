# Guides &ndash; Blogging with Munge

## Overview

This tutorial will go through the process of setting up a blog with the
following features:

* Markdown (with [Redcarpet](https://github.com/vmg/redcarpet))
* Emoji (with [Gemoji](https://github.com/github/gemoji))
* Syntax highlighting (with [Rouge](https://github.com/jneen/rouge))


## Preface

Before we begin, notice that we're interfacing primarily with simple Ruby
[Arrays](http://ruby-doc.org/core/Array.html) and `Item`s.

An `Item` is simply a file's contents and metadata.

These docs are correct as of version `0.10.0`.


## Requirements

Munge requires your Ruby version to be at least `2.1`. Also, these instructions
expects that you have the `bundler` gem installed.


## Installation and Setup

```bash
gem install munge # Install the munge application
munge init blahhg # Create a new website
cd blahhg
```

Running the above steps should setup a basic site:

```
.
├── .gitignore
├── Gemfile
├── Gemfile.lock
├── config
│   ├── _asset_roots.rb
│   ├── routing.rb
│   ├── sass.rb
│   └── view_helpers.rb
├── config.yml
├── data.yml
├── layouts
│   ├── default.html.erb
│   └── sitemap.html.erb
├── rules.rb
├── setup.rb
└── src
    ├── about.html.erb
    ├── assets
    │   ├── fonts
    │   ├── images
    │   ├── javascripts
    │   └── stylesheets
    │       ├── _vars.scss
    │       └── basic.css.scss
    └── index.html.erb

8 directories, 15 files
```

To quickly go over what each file/directory contains

- `config.yml` contains some necessary configuration for Munge to work
- `data.yml` can contain data which will be global to all views
- `layouts/` holds all the layouts that your site has
- `rules.rb` contains all the routing rules and content transformations
  necessary to generate the site
- `setup.rb` loads the files under the `config/` directory. This file is
  generally useful for holding methods and setting up your site's environment.
  It is loaded immediately before parsing `rules.rb`
- `src/` contains all of the site's data and contents
- `dest/` contains the compiled output of the site and is created when running
  `munge build`

Now that this is set, we'll build our site and have a quick preview. Visit
http://localhost:7000 to see the output

```bash
munge server # Start the development server
```

While we're here, let's quickly install some gems. In your Gemfile

```ruby
source 'https://rubygems.org'

gem 'munge'
gem 'redcarpet' # Markdown
gem 'gemoji'    # Emoji
gem 'rouge'     # Syntax highlighting in blog posts
gem 'rake'      # Need this for gemoji
gem 'pry'       # Not needed, just useful for poking around
```

Lastly, let's run `bundle install` again to install everything we'll need. We'll
have to quit and restart `munge server`.


## Individual blog posts

For this example, we'll put our blog posts into `src/posts`.

My personal preference is to have my filenames be the unixtime (eg.
`1462155398.md`). But for now, we'll follow the standard Jekyll way of creating
blog posts, which is `YEAR-MONTH-DAY-title.MARKUP`.

Here's an example of a blog post with a filepath of
`src/posts/2016-05-05-first-post.md`.

```
This is my **first post** and it is Cinco de Mayo!
```

This is represented internally as the following item:

```
#<Munge::Item:0x007f99ba27ad70
 @content="This is my **first post** and it is Cinco de Mayo!\n",
 @frontmatter={},
 @id="posts/2016-05-05-first-post",
 @layout=nil,
 @relpath="posts/2016-05-05-first-post.md",
 @route=nil,
 @stat=
  #<File::Stat
   dev=0x1000005,
   ino=12055454,
   mode=0100644 (file rw-r--r--),
   nlink=1,
   uid=501 (Me),
   gid=20 (staff),
   rdev=0x0 (0, 0),
   size=47,
   blksize=4096,
   blocks=8,
   atime=2016-05-01 22:23:52 -0400 (1462155832),
   mtime=2016-05-01 22:20:44 -0400 (1462155644),
   ctime=2016-05-01 22:20:44 -0400 (1462155644)>,
 @transforms=[],
 @type=:text>
```

Using Ruby's Enumerator methods, we can query for specific items we want. Since
our blog posts will be in the posts directory, we can query for it like this

```ruby
blog_posts = app.nonrouted.select { |item| item.relpath?("posts") }
```

Now, we need to do something with these blog posts we found.

```ruby
def date_from_filename(name)
  y, m, d, title = name.split("-", 4)

  Date.new(y.to_i, m.to_i, d.to_i)
end

def title_from_filename(name)
  y, m, d, title = name.split("-", 4)

  title.split(".", 2)[0]
end

blog_posts.each do |post|
  posted_at  = date_from_filename(post.filename)
  title      = title_from_filename(post.filename)
  post.route = "#{posted_at.strftime("%Y/%m/%d")}/#{title}"
end
```

At this point, we can go to http://localhost:7000/2016/05/05/first-post/, but
markdown formatting doesn't work yet.

There are two ways we can format items, an automatic way and a manual way. The
automatic way provides the item to [Tilt][tilt], which maps extensions to the
appropriate formatter.

```ruby
# Manual method:
blog_posts.each do |post|
  # ...
  post.transform(:tilt, "md")
end

# Automatic (recommended) method
posts.each do |post|
  # ...
  post.transform
end
```

Either method will result in your posts being formatted as markdown. It is
possible to provide multiple extensions to both the filename or the manual
method; this will format the contents in order.

To further illustrate some points, let's now add an image to our next blog post.
This blog post will be named `src/posts/2016-05-08-second-post.md.erb`. To
complicate matters, this post will contain a photo.

```
This is a picture of my family on Mother's Day.

![](<%= path_to(items["posts/2016-05-08-family.jpg"]) %>)
```

As an aside, if you choose to manually transform these items, you will have to
update it to something like the following. As you can see, transformers are
chainable and run in the called order. (Also, we generally don't want to run
`erb` and `md` transformers on binary files.)

```ruby
# Updated manual method
blog_posts.select { |post| post.type == :text }.each do |post|
  # ...
  if post.extensions.include?("erb")
    post.transform(:tilt, "erb")
  end
  post.transform(:tilt, "md")
end
```

## Blog index

Now, let's list all the blog posts on the home page.

First, we'll need a new layout. Let's name this `blog_index.html.erb`.

```html
<% posts.each do |post_item| %>
  <%= render(post_item) %>
<% end %>
```

Next, we'll update our `rules.rb`

```ruby
text_posts = blog_posts.select { |item| item.type == :text }

app.create("index.html.erb", "", posts: text_posts).each do |index|
  index.route = "/"
  index.layout = "blog_index" # Layouts have no extensions
  index.transform
end
```

[tilt]: https://github.com/rtomayko/tilt
