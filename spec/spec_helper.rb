# frozen_string_literal: true

require "bundler/setup"
require "deep_freezer"
require "tmpdir"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.verbose = false
load File.expand_path("support/db/schema.rb", __dir__)

class Test < ActiveRecord::Base; end
class Widget < ActiveRecord::Base; end

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    Dir.mktmpdir("deep_freezer") do |dir|
      DeepFreezer::Base.fixture_path = dir
      example.run
    end
  end

  config.before { Test.delete_all }
end
