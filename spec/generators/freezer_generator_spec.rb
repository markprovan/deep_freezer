# frozen_string_literal: true

require "spec_helper"
require "generators/freezer/freezer_generator"

RSpec.describe FreezerGenerator do
  let(:destination) { Pathname.new(Dir.mktmpdir("freezer_generator")) }

  after { FileUtils.remove_entry(destination) }

  def generate(*args)
    described_class.start(args, destination_root: destination.to_s, shell: Thor::Shell::Basic.new)
  end

  def quietly
    original = $stdout
    $stdout = StringIO.new
    yield
  ensure
    $stdout = original
  end

  describe "with no attributes" do
    before { quietly { generate("Widget") } }

    it "creates a freezer in lib/freezers for every column of the model" do
      expect(destination.join("lib/freezers/widget_freezer.rb").read).to include(
        "class WidgetFreezer < DeepFreezer::Base\n  freeze :id,\n         :name,\n         :email\nend"
      )
    end

    it "can be loaded and used to freeze and defrost a record" do
      load destination.join("lib/freezers/widget_freezer.rb").to_s
      Widget.create!(id: 3, name: "Gizmo", email: "gizmo@example.com")

      WidgetFreezer.new(Widget.find(3)).freeze
      Widget.delete_all
      expect { DeepFreezer::Defrost.load! }.to output(/Loading Widget/).to_stdout

      expect(Widget.find(3)).to have_attributes(name: "Gizmo", email: "gizmo@example.com")
    ensure
      Object.send(:remove_const, :WidgetFreezer) if defined?(WidgetFreezer)
    end
  end

  describe "with attributes" do
    it "freezes only those attributes" do
      quietly { generate("Widget", "name") }

      content = destination.join("lib/freezers/widget_freezer.rb").read
      expect(content).to include("  freeze :name\nend")
      expect(content).not_to include(":email")
    end
  end

  describe "with a namespaced model" do
    it "creates the freezer in a matching subdirectory" do
      quietly { generate("Foo::Bar", "name") }

      expect(destination.join("lib/freezers/foo/bar_freezer.rb").read).to include("class Foo::BarFreezer < DeepFreezer::Base")
    end
  end

  describe "when the model does not exist" do
    it "explains how to pass attributes explicitly and creates nothing" do
      expect { generate("Nonexistent") }
        .to output(/Pass the attributes to freeze explicitly: rails g freezer Nonexistent name email/).to_stderr

      expect(destination.join("lib")).not_to exist
    end
  end
end
