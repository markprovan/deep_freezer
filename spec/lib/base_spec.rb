# frozen_string_literal: true

require "spec_helper"

class TestFreezer < DeepFreezer::Base
  freeze :id, :name, :email

  def email
    "scrambled@itison.com"
  end
end

RSpec.describe DeepFreezer::Base do
  describe "API" do
    it { expect(described_class).to respond_to(:reset!) }
    it { expect(described_class).to respond_to(:freeze) }
  end

  describe "YAML Output" do
    let(:fixture) { DeepFreezer::Base.fixture_path.join("tests.yml") }

    let(:test_instance) do
      Test.new(id: 1, name: "Mark", email: "mark.provan@itison.com")
    end

    before { TestFreezer.new(test_instance).freeze }

    it "creates a file for output based on the model name" do
      expect(fixture).to exist
    end

    it "uses the override method, rather than original value" do
      yaml = fixture.read
      expect(yaml).not_to include("email: mark.provan@itison.com")
      expect(yaml).to include("email: scrambled@itison.com")
    end

    it "correctly formats the YAML for each model" do
      expect(fixture.read).to eql "\n- Test:\n    id: 1\n    name: Mark\n    email: scrambled@itison.com\n"
    end

    it "preserves '---' inside values" do
      TestFreezer.new(Test.new(id: 2, name: "a --- b")).freeze
      expect(fixture.read).to include("a --- b")
    end

    it "removes fixture files on reset!" do
      described_class.reset!
      expect(fixture).not_to exist
    end
  end
end
