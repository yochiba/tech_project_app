# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_22_154608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mid_skill_tags", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "skill_tag_id", null: false
    t.boolean "deleted_flg", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_mid_skill_tags_on_project_id"
    t.index ["skill_tag_id"], name: "index_mid_skill_tags_on_skill_tag_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "company_id", null: false
    t.string "url"
    t.text "required_skills"
    t.text "other_skills"
    t.integer "weekly_attendance"
    t.integer "min_operation_unit"
    t.integer "max_operation_unit"
    t.integer "operation_unit_id"
    t.integer "min_price"
    t.integer "max_price"
    t.integer "price_unit_id"
    t.integer "location_id"
    t.integer "contract_id"
    t.integer "position_id"
    t.boolean "display_flg", default: false, null: false
    t.boolean "deleted_flg", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skill_tags", force: :cascade do |t|
    t.string "skill_name", null: false
    t.text "description"
    t.integer "skill_type_id", null: false
    t.boolean "deleted_flg", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
