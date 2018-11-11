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
# this will create a migration file.
$ bundle exec rails g forced:install

# this will migrate it.
$ bundle exec rails db:migrate
```

After all these are done, add the line below to your routes file.

```ruby
mount Forced::Engine => "/forced"
```

You endpoint and tables are set!

## Usage

If you want a parent for your `Forced::Client` records, you can add `is_versionable` to the desired parent model. Beware that both `Forced::Client` to `Forced::Version` relation and `is_versionable` to `Forced::Client` relation are set to `dependent: :destroy`.

The `Forced::Client`'s polymorphic relation is optional as well. So, you can use the gem without setting a parent class relation. It'll work exactly the same.

For example, imagine you have a `Brand` model to identify each application. Adding the line below to your model, will hold a relation for `has_many :clients`

```ruby
class Brand < ApplicationRecord
  # ...

  # If you haven't read the above paragraph, please do.
  # This is optional.
  is_versionable

  # ...
end
```

Then, you can call your clients with;

```ruby
Brand.find(:id).clients
# => #<ActiveRecord::Associations::CollectionProxy [...]>

Brand.find(:id).clients.to_sql
# => "SELECT "forced_clients".* FROM "forced_clients" WHERE "forced_clients"."owner_id" = :id AND "forced_clients"."owner_type" = 'Brand'"
```

The Forced module needs to get the coming request to prepare the response. As long as request headers contains `X-Platform` and `X-Client-Version`, you are good to go.

* `X-Platform` will need to match with `Forced::Client identifier:string` attribute in order to search the available versions.
* `X-Client-Version` should contain a semantic version number, e.g. `1.0.0`

Then send a `GET` request to `{{url}}/forced/status`. This will return the below JSON. (`/forced` is where you mounted the engine!)

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

To change the default response from the mounted endpoint, create a `StatusController` like below.

```ruby
# In order this to work,
# you need to create this file in the correct path,
# that is;
#
# app/controllers/forced/status_controller.rb

module Forced
  class StatusController < ::ApplicationController
    def index
      response = Forced::Response.call(request)

      # Do what you want to do with the response hash.
    end
  end
end
```

To create a record, you can use your Rails console. `Forced::Client` is polymorphic and keeps `foreign_key` and `foreign_type` columns as `owner_#`. So, when you are creating a `Forced::Client` instance, use `owner:` for your reference column, e.g. `Forced::Client.create(owner: Brand.first)`

```ruby
Forced::Client.new
# => #<Forced::Client id: nil, owner_type: nil, owner_id: nil, identifier: nil, deleted_at: nil, created_at: nil, updated_at: nil>

Forced::Version.new
# => #<Forced::Version id: nil, client_id: nil, version: nil, force_update: false, changelog: nil, deleted_at: nil, created_at: nil, updated_at: nil>
```

## Responses

All available under `Forced::MESSAGES` hash table. You can override the values as you wish. Also checkout the `check_update_status` private method in `base.rb` to understand the cases.

## Upgrading from 0.2.0 to 1.1.2

New migrations and tables have a different name, so, unless you are using custom calls, you can optionally and gradually create a migration for old table and move your records into the new table.

If you had some trouble or found something that wasn't suppose to be there, feel free to open an issue.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
