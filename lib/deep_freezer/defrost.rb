class DeepFreezer::Defrost

  def self.load!
    path = DeepFreezer::Base.fixture_path.join("**/*.yml")
    Dir.glob(path).each do |file|
      objects = YAML.load(File.read(file))
      puts "Loading #{objects.first.keys.first}"
      objects.each do |object|
        instance = self.hash_to_instance(object)
        sql = self.sql_for(instance)
        ActiveRecord::Base.connection.execute sql
      end
    end
  end

  def self.hash_to_instance(object)
    klass = object.keys.first
    attrs = object[klass]
    instance = klass.constantize.new

    attrs.keys.each do |a|
      instance.send("#{a}=", attrs[a])
    end
    
    instance
  end

  def self.sql_for(record)
    values = record.send(:arel_attributes_with_values_for_create, record.attribute_names)

    model = record.class
    scope = model.unscoped

    im = scope.arel.create_insert
    im.into model.arel_table

    substitutes, binds = scope.substitute_values(values)
    im.insert substitutes

    record.class.connection.to_sql(im, binds)
  end
end
