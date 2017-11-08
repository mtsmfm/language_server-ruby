# LanguageServer

[Alpha quality]

A Ruby Language Server implementation.

## Installation

If you are using vscode, install [ruby-lsc](https://marketplace.visualstudio.com/items?itemName=mtsmfm.ruby-lsc) extension.

### Docker

Simply you can pull from [docker hub](https://hub.docker.com/r/mtsmfm/language_server-ruby/)

    $ docker pull mtsmfm/language_server-ruby

### Ruby gem

Add this line to your application's Gemfile:

```ruby
gem 'language_server'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install language_server

## Usage

Currently, language_server-ruby supports only stdio to communicate.

### Docker

    $ docker run mtsmfm/language_server-ruby

### Ruby gem

    $ language_server-ruby

## Development

### Requirements

#### docker, docker-compose

https://docs.docker.com/engine/installation

### Setup

    $ git clone https://github.com/mtsmfm/language_server-ruby.git
    $ cd language_server-ruby
    $ docker-compose run app bin/setup

### Run test

You can run test via m:

    $ docker-compose run app bin/m
    $ docker-compose run ruby-2-3 bin/m
    $ docker-compose run ruby-2-2 bin/m

Or run via guard:

    $ docker-compose run app bin/guard
    $ docker-compose run ruby-2-3 bin/guard
    $ docker-compose run ruby-2-2 bin/guard

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mtsmfm/language_server-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

