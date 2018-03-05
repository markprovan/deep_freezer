class DeepFreezer::Base

  class << self
    attr_accessor :attrs, :model, :fixture_path
  end

  def initialize(obj)
    @obj = obj
  end

  def self.freeze(*attrs)
    @attrs = attrs
  end

  def self.model(model)
    @model = model
  end

  def freeze
    freezable = @obj.class.new
    self.class.attrs.each do |attr|
      if self.respond_to?(attr)
        freezable.send("#{attr}=", self.send(attr))
      else
        freezable.send("#{attr}=", @obj.send(attr))
      end
    end

    yaml = ({ "#{freezable.class.to_s.tableize}_#{freezable.id.to_s}" => freezable.attributes }.to_yaml).gsub("---", "")

    write_to_file yaml, freezable.class.to_s.tableize
  end

  def self.reset!
    path = DeepFreezer::Base.fixture_path.to_s + "/*.yml"
    Dir.glob(path).each { |file| File.delete(file) }
  end

  private

    def write_to_file(yaml, file_name)
      path = DeepFreezer::Base.fixture_path.to_s + "/#{file_name.pluralize}.yml"
      dirname = File.dirname(path)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end

      open(path, 'a+') { |file| file << yaml }
    end
end
