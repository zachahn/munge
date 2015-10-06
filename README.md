# Munge

[![Build Status](https://travis-ci.org/zachahn/munge.svg?branch=master)](https://travis-ci.org/zachahn/munge)
[![Code Climate](https://codeclimate.com/github/zachahn/munge/badges/gpa.svg)](https://codeclimate.com/github/zachahn/munge)
[![Test Coverage](https://codeclimate.com/github/zachahn/munge/badges/coverage.svg)](https://codeclimate.com/github/zachahn/munge/coverage)

Munge is a static site generator aiming to simplify complex build rules.

SemVer will be followed once 1.0.0 is released.
Until then,
the API should be considered experimental.


## Features

- No metaprogramming
- Suitable for large, complex sites (e.g., multiple blogs with different templates, a single blog with multiple data sources)
- Concise rule definition
- Rules defined by iterating through arrays and modifying objects


## Caveats

- Not optimized (Pull requests welcome, gradual optimizations preferred)
- Rules can seem pretty dense (because of its conciseness)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'munge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install munge


## Usage

After installing your gem, you can start a project using the command line client.

```
munge init path/to/project
```

The three main files of your application are `config.yml`, `data.yml`, and `rules.rb`.

Here's an example `rules.rb` for a blog.

```ruby
# home page
app.source
  .select { |item| item.id == "home" }      # looks for items where path is "src/home.*"
  .each   { |item| item.route = "" }        # sets output file to "/index.html"
  .each   { |item| item.layout = "default"} # sets layout to "layouts/default.*"
  .each   { |item| item[:title] = "home" }  # sets additional frontmatter variables
  .each   { |item| item.transform(:tilt) }  # have Tilt compile this file

# blog posts
app.source
  .select { |item| item.relpath =~ %r(^posts/) }          # looks for items in "src/posts/**/*"
  .each   { |item| item.route = "blog/#{item.basename}" } # sets output file to "/blog/#{basename}/index.html"
  .each   { |item| item.layout = "post" }
  .each   { |item| item.transform }                       # sets transform to Tilt (default)

# blog index
posts_for_index =
  app.source
    .find_all { |item| item.route =~ %r(^blog/) }
    .sort_by  { |item| item.route }
    .reverse

app.create("blog/index.html.erb", "", posts: posts_for_index) do |item|
  item.route  = "blog" # sets output file to "/blog/index.html"
  item.layout = "list"
  item.transform
end
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zachahn/munge.

Please open an issue before creating a pull request to discuss whether any new feature should be included as part of the core library or as an external plugin.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
