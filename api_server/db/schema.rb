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

ActiveRecord::Schema.define(version: 2020_11_15_075448) do

  create_table "contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "contract_name", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "industries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "industry_name", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "location_name", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mid_positions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "position_id", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position_id"], name: "index_mid_positions_on_position_id"
    t.index ["project_id"], name: "index_mid_positions_on_project_id"
  end

  create_table "mid_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "tag_id", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_mid_tags_on_project_id"
    t.index ["tag_id"], name: "index_mid_tags_on_tag_id"
  end

  create_table "positions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "position_name", null: false
    t.string "position_name_search", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "company_id", null: false
    t.string "company", null: false
    t.string "url"
    t.text "required_skills"
    t.text "other_skills"
    t.text "environment"
    t.integer "weekly_attendance"
    t.integer "min_operation_unit"
    t.integer "max_operation_unit"
    t.integer "operation_unit_id"
    t.string "operation_unit"
    t.integer "min_price"
    t.integer "max_price"
    t.integer "price_unit_id"
    t.string "price_unit"
    t.bigint "location_id"
    t.bigint "contract_id"
    t.bigint "industry_id"
    t.integer "display_flg", default: 0, null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contract_id"], name: "index_projects_on_contract_id"
    t.index ["industry_id"], name: "index_projects_on_industry_id"
    t.index ["location_id"], name: "index_projects_on_location_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tag_name", null: false
    t.string "tag_name_search", null: false
    t.string "tag_type_name", default: "その他", null: false
    t.integer "tag_type_id", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
