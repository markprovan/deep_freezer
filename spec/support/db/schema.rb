# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.string "email"
  end
end
