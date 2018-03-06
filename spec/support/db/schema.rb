ActiveRecord::Schema.define(version: 20180124133156) do
  create_table "tests", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
  end
end