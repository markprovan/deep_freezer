# frozen_string_literal: true

class DeepFreezer::Base
  class << self
    attr_reader :attrs, :model, :fixture_path

    def fixture_path=(path)
      @fixture_path = path && Pathname.new(path)
    end
  end

  def self.freeze(*attrs)
    @attrs = attrs
  end

  def self.model(model)
    @model = model
  end

  def self.reset!
    Dir.glob(DeepFreezer::Base.fixture_path.join("*.yml")).each { |file| File.delete(file) }
  end

  def initialize(obj)
    @obj = obj
  end

  def freeze
    freezable = @obj.class.new
    self.class.attrs.each do |attr|
      value = respond_to?(attr) ? public_send(attr) : @obj.public_send(attr)
      freezable.public_send("#{attr}=", value)
    end

    # Drop only the leading document marker, so values containing "---" survive.
    yaml = [{ freezable.class.to_s => freezable.attributes }].to_yaml.delete_prefix("---")

    write_to_file yaml, freezable.class.to_s.tableize
  end

  private

  def write_to_file(yaml, file_name)
    path = DeepFreezer::Base.fixture_path.join("#{file_name.pluralize}.yml")
    FileUtils.mkdir_p(path.dirname)
    File.open(path, "a") { |file| file << yaml }
  end
end
