---
layout: post
title: Handling Force Update on Mobile Apps via Backend API
tags: [rails]
deprecated: true
language: EN
---

> **Deprecation Warning**
>
> This post is really old, tread carefully...

I already wrote a gem called **forced** for Rails APIs. You can found that on my github page using this link: [**rwxdash/forced**](https://github.com/rwxdash/forced).

The content below is describing the gist of it. Have fun.

---

If you are supporting multiple mobile apps with your API, it's nice to have the ability to force the update on those apps in the future. Unfortunately, as far as I know, there isn't a robust solution to this on the client end. So, it's reasonable to solve this on your backend.

Below is my solution to this problem.

First, I created a model called `AppVersion`. You can call this whatever you want, but this is going to be the table where I keep version records for clients.

`AppVersion` model is something like this.

```ruby
# == Schema Information
#
# Table name: app_versions
#
#  id           :bigint(8)        not null, primary key
#  client       :integer
#  version      :string(255)
#  changelog    :text
#  force_update :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AppVersion < ApplicationRecord
  enum client: [:android, :ios]

  validates :client, presence: true
  validates :version, presence: true, length: { maximum: 255 }
end
```

Then, I created a controller called `StatusController` and add that to the `routes` file. This endpoint is for `only: [:index]`. Of course, if you need more than that, you can always adjust this to your needs.

Now, this is the tricky part. There is two information that is crucial for this controller. `X-Client-Version` and `X-Platform`. They both need to come from the client as request headers.

The logic you are going to see could seem a bit crowded and dirty, but I needed to check for the `nil` cases just in case.

The **StatusController** starts like this.

```ruby
class StatusController < ApplicationController
  def index
    client = request.headers['X-Platform'].to_s.downcase
    client_version = request.headers['X-Client-Version']

    client_version_records = (client && client_version ? AppVersion.where(client: client) : nil)

    versions_after_client = client_version_records&.where('version > ?', client_version)
    latest_app_version = client_version_records&.last
    any_forced_in_the_future = versions_after_client&.pluck(:force_update)&.any?
  end
end
```

The **client_version_records** variable checks if `client` and `client_version` is present in the coming request. If so, it's going to return the **AppVersion** records that match with the client OS.

**versions_after_client** is pretty obvious. It'll hold the records that have a higher version number than the client. I'll explain why we need to create later. **latest_app_version** is the latest records in our database. And at last, **any_forced_in_the_future** is a `boolean` variable that returns true if there is any `forced_update` in the `versions_after_client` collection.

We are almost done. Now, we can create our logic and responses. Now, I have a method called `render_object` already, but don't get confused. You can just simply type `render json:` instead.

In the status controller, I've put a private method called `check_update_status` that takes three arguments: **client_version**, **latest_app_version**, **any_forced_in_the_future**.

```ruby
class StatusController < ApplicationController
  # ...

  private

  def check_update_status(client_version, latest_app_version, any_forced_in_the_future)
    nil_report = []
    nil_report << :app_version_returned_nil if latest_app_version.nil?
    nil_report << :client_version_returned_nil if client_version.nil?

    return nil_report.join(', ') if !nil_report.empty?

    client_v = Gem::Version.new(client_version)
    latest_v = Gem::Version.new(latest_app_version.version)

    case
    when client_v == latest_v
      return :no_update
    when client_v < latest_v
      any_forced_in_the_future ? :force_update : :just_update
    when client_v > latest_v
      return :client_is_ahead_of_backend
    else
      return :something_went_wrong
    end
  end
end
```

OK. Let me explain this a bit here and oversee the scenarios. I assume `nil_report` is pretty self-explanatory, so I'm skipping that.

In the **first case**, if both versions are the same I return `:no_update`. I'm checking this first so it won't get in our way and get caught early. I'm sure you've already solved a **FizzBuzz** problem, so... You get me, right?

In the **second case**, if the client version is lower than our latest record, it means that the user has an update to do. So, the question here is, is any of the updates comes after the client's version forced? **versions_after_client** has to be created to solve this case. Because the user could be missing more than one update, and if any of them is forced it means we should force the user to not miss that update.

The **third case** has very little chance to happen, but it could happen if you forget about things, so it needed to be checked. If the client version is bigger than our latest record, it simply returns the message `:client_is_ahead_of_backend` and we need to add some **AppVersion** records in our database.

We're almost done. We just need to return this information.

```ruby
class StatusController < ApplicationController
  def index
    # ...

    status = {
      update_status: check_update_status(client_version, latest_app_version, any_forced_in_the_future)
    }

    render_object(status)
  end

  # ...
end
```

Done! 🎉

Now your mobile clients can send a request to this endpoint and check if the update should be forced if you've added the proper records.
