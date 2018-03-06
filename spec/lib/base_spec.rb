require 'spec_helper'
require 'active_record'
require 'nulldb_rspec'

RSpec.describe DeepFreezer::Base do

  describe 'API' do
    it "responds to reset!" do
      expect(described_class.respond_to?(:reset!)).to eq true
    end

    it "responds to freeze" do
      expect(described_class.respond_to?(:freeze)).to eq true
    end
  end

  describe 'YAML Output' do
    let(:test_freezer) do
      class TestFreezer < DeepFreezer::Base
        freeze :id,
               :name,
               :email

        def email
          "scrambled@itison.com"
        end
      end
      TestFreezer
    end

    let(:test_model) do
      class Test < ActiveRecord::Base;end
      Test
    end

    let(:test_instance) do 
      instance = test_model.new
      instance.id = 1
      instance.name = "Mark"
      instance.email = "mark.provan@itison.com"
      instance
    end

    before do
      DeepFreezer::Base.fixture_path = File.join("/tmp")
      NullDB.configure {|ndb| def ndb.project_root;File.join("spec", "support");end}
      ActiveRecord::Base.establish_connection(adapter: :nulldb)
      DeepFreezer::Base.reset!

      test_freezer.new(test_instance).freeze
    end

    it 'creates a file for output based on the model name' do
      expect(File.exists?("/tmp/tests.yml")).to eq true
    end

    it 'uses the override method, rather than original value' do
      yaml = File.read("/tmp/tests.yml")
      expect(yaml).to_not include("email: mark.provan@itison.com")
      expect(yaml).to include("email: scrambled@itison.com")
    end

    it 'correctly formats the YAML for each model' do
      yaml = "\n- Test:\n    id: 1\n    name: Mark\n    email: scrambled@itison.com\n"
      expect(File.read("/tmp/tests.yml")).to eql yaml
    end
  end
end