# FaradayMiddleware::Msgpack

[![Build Status](https://secure.travis-ci.org/hotchpotch/faraday_middleware-msgpack.png?branch=master)](http://travis-ci.org/hotchpotch/faraday_middleware-msgpack)


## Installation

Add this line to your application's Gemfile:

    gem 'faraday_middleware-msgpack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday_middleware-msgpack

## Examples

```
require 'faraday_middleware/msgpack'

connection = Faraday.new do |conn|
  conn.request :msgpack
  conn.response :msgpack,  :content_type => %r{\bapplication/x-msgpack$}
  conn.adapter Faraday.default_adapter
end
```

