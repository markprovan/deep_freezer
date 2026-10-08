# frozen_string_literal: true

require "rails/generators"

# Generates a freezer for a model:
#
#   rails g freezer User
#
# See USAGE for details.
class FreezerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :attributes, type: :array, default: [], banner: "attribute attribute"

  def create_freezer_file
    # Resolve the attributes first: Thor creates the file before rendering the
    # template, so a failure while rendering would leave an empty file behind.
    freezer_attributes

    template "freezer.rb.tt", File.join("lib/freezers", class_path, "#{file_name}_freezer.rb")
  end

  private

  def freezer_class_name
    "#{class_name}Freezer"
  end

  # Explicit attributes win; otherwise every column of the model.
  def freezer_attributes
    @freezer_attributes ||= attributes.empty? ? model_columns : attributes.map(&:name)
  end

  def model_columns
    model = class_name.safe_constantize
    unless model.is_a?(Class) && model < ActiveRecord::Base
      raise Thor::Error, "Could not find the model #{class_name}. " \
                         "Pass the attributes to freeze explicitly: rails g freezer #{class_name} name email"
    end

    model.column_names
  rescue ActiveRecord::ActiveRecordError => e
    raise Thor::Error, "Could not read the columns of #{class_name} (#{e.message}). " \
                       "Pass the attributes to freeze explicitly: rails g freezer #{class_name} name email"
  end
end
