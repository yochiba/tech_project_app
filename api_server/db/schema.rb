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

ActiveRecord::Schema.define(version: 2020_12_12_172325) do

  create_table "contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "contract_name", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "industries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "industry_name", null: false
    t.string "industry_name_search", null: false
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

  create_table "mid_industries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "industry_id", null: false
    t.integer "deleted_flg", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["industry_id"], name: "index_mid_industries_on_industry_id"
    t.index ["project_id"], name: "index_mid_industries_on_project_id"
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
    t.string "title", null: false, comment: "案件タイトル"
    t.text "description", comment: "案件説明"
    t.integer "company_id", null: false, comment: "案件掲載企業ID"
    t.string "company", null: false, comment: "案件掲載企業名"
    t.string "url", default: "", null: false, comment: "案件URL"
    t.text "required_skills", comment: "必須スキル"
    t.text "other_skills", comment: "尚可スキル"
    t.text "environment", comment: "開発環境"
    t.integer "weekly_attendance", comment: "出勤日数/週"
    t.integer "min_operation_unit", default: 0, null: false, comment: "最低稼働時間"
    t.integer "max_operation_unit", default: 0, null: false, comment: "最高稼働時間"
    t.integer "operation_unit_id", comment: "稼働時間単位ID"
    t.string "operation_unit", comment: "稼働時間単位"
    t.integer "min_price", default: 0, null: false, comment: "最低単価"
    t.integer "max_price", default: 0, null: false, comment: "最高単価"
    t.integer "price_unit_id", comment: "単価単位ID"
    t.string "price_unit", comment: "単価単位"
    t.bigint "location_id", comment: "勤務地"
    t.bigint "contract_id", comment: "契約形態"
    t.integer "display_flg", default: 0, null: false
    t.integer "deleted_flg", default: 0, null: false, comment: "削除フラグ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contract_id"], name: "index_projects_on_contract_id"
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
