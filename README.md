# Munge

Munge is a static site generator aiming to simplify complex build rules.

SemVer will be followed once 1.0.0 is released.
Until then,
the API should be considered experimental.


## Usage

**Directory structure**

```
dest/
src/
  layouts/
    layout.html
  index.html
application.rb
config.yml
Gemfile
```

**`application.rb`**

```ruby
require "munge"

app = Munge::Application.new("./config.yml")

app.source
  .reject { |item| item.path.relative =~ %r(^layouts/) }
  .each   { |item| item.route = item.path.dirname }
  .map    { |item| item.path.dirname }

app.write
```

**`config.yml`**

```yaml
---
source: src
dest: dest
binary_extensions:
  - jpg
  - jpeg
  - png
  - gif
  - ico
index: index.html
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'munge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install munge


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zachahn/munge.

Please open an issue before creating a pull request to discuss whether any new feature should be included as part of the core library or as an external plugin.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
