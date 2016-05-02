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

These docs are correct as of version `0.9.0`.


## Installation and Setup

```bash
gem install munge # Install the munge application
munge init blahhg # Create a new website
cd blahhg
bundle install    # Install dependencies
```

Running the above steps should setup a basic site:

```
.
├── Gemfile
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

Now that this is set, we'll build our site and have a quick preview. Visit
http://localhost:7000 to see the output

```bash
munge build       # Build your website into `dest/`
munge view        # Start the munge server
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

Lastly, let's run `bundle install` again to install everything we'll need.


## Individual blog posts

For this example, we'll put our blog posts into `src/posts`.

My personal preference is to have my filenames be the unixtime (eg.
`1462155398.md`). But for now, we'll follow the standard Jekyll way of creating
blog posts, which is `YEAR-MONTH-DAY-title.MARKUP`.

Here's an example of a blog post.

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
  # ...
end

def title_from_filename(name)
  # ...
end

blog_posts.each do |post|
  posted_at  = date_from_filename(post.filename)
  title      = title_from_filename(post.filename)
  post.route = "#{posted_at.year}/#{posted_at.month}/#{posted_at.day}/#{title}"
end
```

At this point, we can go to http://localhost:7000/2016/05/05/first-post/, but
markdown formatting doesn't work yet.
