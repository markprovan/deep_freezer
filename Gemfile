# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# CI sets ACTIVERECORD_VERSION (e.g. "7.2") to test against a specific release.
gem "activerecord", "~> #{ENV.fetch("ACTIVERECORD_VERSION")}.0" if ENV["ACTIVERECORD_VERSION"]
