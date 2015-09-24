# Munge

[![Build Status](https://travis-ci.org/zachahn/munge.svg?branch=master)](https://travis-ci.org/zachahn/munge)
[![Code Climate](https://codeclimate.com/github/zachahn/munge/badges/gpa.svg)](https://codeclimate.com/github/zachahn/munge)
[![Test Coverage](https://codeclimate.com/github/zachahn/munge/badges/coverage.svg)](https://codeclimate.com/github/zachahn/munge/coverage)

Munge is a static site generator aiming to simplify complex build rules.

SemVer will be followed once 1.0.0 is released.
Until then,
the API should be considered experimental.


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


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zachahn/munge.

Please open an issue before creating a pull request to discuss whether any new feature should be included as part of the core library or as an external plugin.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
