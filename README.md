# Forced

This plugin is for Rails APIs that supports multiple mobile applications and want to force an update to those applications.

Read the link below to get some insight.

* [Handling Force Update on Mobile Apps / Rusty Neuron](https://rustyneuron.net/2018/07/12/handling-force-update-on-mobile-apps/)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'forced'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install forced
```

And then, run:
```bash
$ bundle exec rails db:migrate
```

After all these are done, add the line below to your routes file.

```ruby
mount Forced::Engine => "/forced"
```

You are all set!

## Usage

Module needs to get the coming request to prepare the response. As long as request headers contains `X-Platform` and `X-Client-Version`, you are good to go.


Then send a `GET` request to `{{url}}/forced/status`. This will return the below JSON.

```json
{
    "update": "force_update",
    "latest_version": "1.0.0",
    "current_time": "2018-07-13T16:28:22.829Z"
}
```

If you want to return some version of this hash, you can access the response by calling the `Response.call(request)` method. See below.

```ruby
response = Forced::Response.call(request)
```

Client enum is `[:android, :ios]` at default. To change it, open up an initializer for `Forced` module and change the constant named `CLIENT_ENUM`.

```ruby
module Forced
  CLIENT_ENUM = [:android, :ios]
end
```

To create a record, you can use your Rails console.

```ruby
Forced::AppVersion.new

# => #<Forced::AppVersion id: nil, client: nil, version: nil, force_update: false, changelog: nil, created_at: nil, updated_at: nil>
```

## Responses

All available under `Forced::MESSAGES` hash table. You can override the values as you wish. Also checkout the `check_update_status` private method in `base.rb` to understand the cases.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
