require 'spec_helper'

RSpec.describe DeepFreezer::Defrost do

  describe "API" do
    it "responds to load!" do
      expect(described_class.respond_to?(:load!)).to eq true
    end
  end

  describe 'SQL Conversion' do
    let(:test_model) do
      class Test < ActiveRecord::Base;end
      Test
    end

    let(:test_instance) do 
      instance = test_model.new
      instance.id = 1
      instance.name = "Mark"
      instance
    end

    it "generates the correct SQL insert statement for a model" do
      # When running against an actual DB, values appear in the SQL statement correctly.
      # I think using NullDB affects this slightly, maybe not supporting prepared statements.
      # We can at least test for an insert into the correct table and columns.

      expect(described_class.sql_for(test_instance)).to eql "INSERT INTO tests (id, name) VALUES (?, ?)"
    end
  end
end