# Deep Freezer v1.0.0
## Freeze ActiveRecord models to Rails compatible fixtures.

This gem allows you to 'freeze' your ActiveRecord models to create repeatable datasets for development.

---

[![Maintainability](https://api.codeclimate.com/v1/badges/48d23870f47ee5a40404/maintainability)](https://codeclimate.com/github/markprovan/deep_freezer/maintainability)
[ ![Codeship Status for markprovan/deep_freezer](https://app.codeship.com/projects/4e7228d0-0388-0136-cef4-7e35bd29612c/status?branch=master)](https://app.codeship.com/projects/280310)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deep_freezer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install freezer

## Usage

### Config
Be sure to load your freezer classes in `development.rb`
```
Dir.glob(Rails.root.join("lib", "freezers", "*.rb")).each do |file|
  require file
end
```

Create an initializer and set the path for fixtures to be saved

`Freezer::Base.fixture_path = Rails.root.join("db", "seeds")`

### Define Freezers

Define a `DeepFreezer` for your model

```
class PostFreezer < DeepFreezer::Base

  freeze :id,
         :title,
         :body,
         :created_at,
         :updated_at

end
```

#### Overriding Attributes

Attributes can be overrode at time of freeze, similar to ActiveModel Serializers, by defining a method with the same name as the attribute name.

```
class PostFreezer < DeepFreezer::Base

  freeze :id,
         :title,
         :body,
         :created_at,
         :updated_at

  def title
    "Frozen Title"
  end

end
```

### Perform Freeze

And then write a script to select and freeze the records you want:

```
  posts = Post.all.limit(10)
  posts.map { |p | PostFreezer.new(p).freeze }
```

This will result in a `posts.yml` file in `db/seeds` which can be loaded by adding `DeepFreezer::Defrost.load!` to your `seeds.rb` file.

### Reset Fixtures

Fixtures can be deleted manually in the directory, or by running `Freezers::Base.reset!`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/itison/freezer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Freezer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/freezer/blob/master/CODE_OF_CONDUCT.md).
