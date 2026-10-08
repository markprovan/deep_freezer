# frozen_string_literal: true

require "spec_helper"

RSpec.describe DeepFreezer do
  it "has a version number" do
    expect(DeepFreezer::VERSION).not_to be nil
  end
end
