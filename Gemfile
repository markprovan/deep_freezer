# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# CI and the Dockerfile set ACTIVERECORD_VERSION (e.g. "7.2") to test against a specific Rails release.
activerecord_version = ENV.fetch("ACTIVERECORD_VERSION", "")
unless activerecord_version.empty?
  rails_version = "~> #{activerecord_version}.0"
  gem "activerecord", rails_version
  gem "railties", rails_version
end
