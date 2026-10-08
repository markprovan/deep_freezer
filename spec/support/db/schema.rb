# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.string "email"
  end

  create_table "widgets", force: :cascade do |t|
    t.string "name"
    t.string "email"
  end
end
