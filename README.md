# Sapine

Sabine adds boilerplate code for common API parameter handling like limit, offset, order and filtering by state.

## Installation

Add this line to your application's Gemfile:

    gem 'sapine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sapine

## Usage

Include Sapine in you API controller and use its chainable methods to build your query. It handles common API parameters like page, limit, state, etc.

```
class ResourceController < ApplicationController
  include Sapine

  def index
    @resources = index_options(Resource)
  end
end
```

After you call index_options you can access api_meta to get paging and count information.

```
render json: @resources, meta: api_meta
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sapine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
