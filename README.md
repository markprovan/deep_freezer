![Logo](https://s3.amazonaws.com/mp-github-files/logo.png)

## Freeze production like data for development
This gem allows you to 'freeze' your ActiveRecord models to create repeatable datasets for development.

---

[![Maintainability](https://api.codeclimate.com/v1/badges/48d23870f47ee5a40404/maintainability)](https://codeclimate.com/github/markprovan/deep_freezer/maintainability)
[![CI](https://github.com/markprovan/deep_freezer/actions/workflows/ci.yml/badge.svg)](https://github.com/markprovan/deep_freezer/actions/workflows/ci.yml)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deep_freezer'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install deep_freezer
```

Requires Ruby 3.1+ and ActiveRecord 7.1+.

## Usage

### Config
Be sure to load your freezer classes in `development.rb`
```ruby
Dir.glob(Rails.root.join("lib", "freezers", "**", "*.rb")).each do |file|
  require file
end
```

Create an initializer and set the path for fixtures to be saved

```ruby
DeepFreezer::Base.fixture_path = Rails.root.join("db", "seeds")
```

### Define Freezers

Generate a freezer for a model:

```sh
rails g freezer Post
```

This creates `lib/freezers/post_freezer.rb` with every column of the model (it needs a database connection). Pass attributes to freeze only those, for example `rails g freezer Post title body`. Namespaced models go in matching subdirectories: `rails g freezer Admin::User` creates `lib/freezers/admin/user_freezer.rb`.

Or define a `DeepFreezer` for your model by hand:

```ruby
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

```ruby
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

```ruby
  posts = Post.all.limit(10)
  posts.map { |p | PostFreezer.new(p).freeze }
```

This will result in a `posts.yml` file in `db/seeds` which can be loaded by adding `DeepFreezer::Defrost.load!` to your `seeds.rb` file.

### Reset Fixtures

Fixtures can be deleted manually in the directory, or by running `DeepFreezer::Base.reset!`, which also clears subdirectories used by namespaced models.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Releasing

Releases are published by GitHub Actions using RubyGems [trusted publishing](https://guides.rubygems.org/trusted-publishing/), so no API key is needed.

1. Update `VERSION` in `lib/deep_freezer/version.rb` and add an entry to `CHANGELOG.md`.
2. Merge to `master`, then create a release in the GitHub UI with a new tag (e.g. `v2.0.0`) targeting `master`.

The `Release` workflow checks the tag matches the version, runs the specs and RuboCop, and pushes the gem to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/markprovan/deep_freezer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DeepFreezer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/markprovan/deep_freezer/blob/master/CODE_OF_CONDUCT.md).
