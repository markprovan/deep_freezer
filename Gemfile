# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# CI sets ACTIVERECORD_VERSION (e.g. "7.2") to test against a specific Rails release.
if ENV["ACTIVERECORD_VERSION"]
  rails_version = "~> #{ENV.fetch("ACTIVERECORD_VERSION")}.0"
  gem "activerecord", rails_version
  gem "railties", rails_version
end
