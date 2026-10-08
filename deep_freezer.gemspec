# frozen_string_literal: true

require_relative "lib/deep_freezer/version"

Gem::Specification.new do |spec|
  spec.name          = "deep_freezer"
  spec.version       = DeepFreezer::VERSION
  spec.authors       = ["Mark Provan"]
  spec.email         = ["markgprovan@gmail.com"]

  spec.summary       = "Freeze ActiveRecord models to Rails compatible fixtures."
  spec.description   = "This gem allows you to 'freeze' your ActiveRecord models to Rails compatible fixture files. This allows you to store real data statically for quick start dev/staging environments."
  spec.homepage      = "https://github.com/markprovan/deep_freezer"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1"

  spec.metadata["allowed_push_host"]     = "https://rubygems.org"
  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files         = Dir["lib/**/*"].select { |f| File.file?(f) } + ["LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 7.1", "< 9.0"

  spec.add_development_dependency "irb"
  spec.add_development_dependency "railties", ">= 7.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rubocop", "~> 1.70"
  spec.add_development_dependency "sqlite3", ">= 2.1"
end
