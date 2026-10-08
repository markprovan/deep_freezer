# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeepFreezer::Defrost do
  describe "API" do
    it { expect(described_class).to respond_to(:load!) }
  end

  describe "Loading YAML" do
    let(:parsed_yaml) { YAML.safe_load("\n- Test:\n    id: 1\n    name: Mark\n").first }
    let(:instance) { described_class.hash_to_instance(parsed_yaml) }

    it "creates the correct type of model instance" do
      expect(instance).to be_a(Test)
    end

    it "correctly sets each attribute" do
      expect(instance.id).to eql 1
      expect(instance.name).to eql "Mark"
    end
  end

  describe "SQL Conversion" do
    let(:test_instance) { Test.new(id: 1, name: "Mark") }

    it "generates the correct SQL insert statement for a model" do
      expect(described_class.sql_for(test_instance)).to eql(
        'INSERT INTO "tests" ("id", "name", "email") VALUES (1, \'Mark\', NULL)'
      )
    end

    it "escapes quotes in values" do
      sql = described_class.sql_for(Test.new(id: 1, name: "O'Brien"))
      expect(sql).to include("'O''Brien'")
    end
  end

  describe "round trip" do
    before do
      Class.new(DeepFreezer::Base) { freeze :id, :name, :email }
           .new(Test.new(id: 7, name: "Mark", email: "mark@example.com")).freeze
      Test.delete_all
    end

    it "loads frozen fixtures back into the database" do
      expect { described_class.load! }.to output(/Loading Test/).to_stdout
      expect(Test.find(7)).to have_attributes(name: "Mark", email: "mark@example.com")
    end
  end
end
