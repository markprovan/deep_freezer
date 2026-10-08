# frozen_string_literal: true

module DeepFreezer
  class Defrost
    PERMITTED_YAML_CLASSES = [Date, Time, Symbol, BigDecimal].freeze

    def self.load!
      Dir.glob(DeepFreezer::Base.fixture_path.join("**/*.yml")).each do |file|
        objects = YAML.safe_load_file(file, permitted_classes: PERMITTED_YAML_CLASSES, aliases: true)
        next if objects.blank?

        puts "Loading #{objects.first.keys.first}"
        objects.each do |object|
          ActiveRecord::Base.connection.execute sql_for(hash_to_instance(object))
        end
      end
    end

    def self.hash_to_instance(object)
      klass, attrs = object.first
      instance = klass.constantize.new

      attrs.each { |name, value| instance.public_send("#{name}=", value) }

      instance
    end

    def self.sql_for(record)
      model = record.class
      table = model.arel_table

      values = record.attributes_for_database.map { |name, value| [table[name], value] }

      insert = Arel::InsertManager.new(table)
      insert.insert(values)

      model.connection.to_sql(insert)
    end
  end
end
