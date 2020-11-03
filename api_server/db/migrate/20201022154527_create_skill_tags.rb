# frozen_string_literal: true

class CreateSkillTags < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_tags do |t|
      t.string :skill_tag_name, null: false
      t.string :skill_tag_name_search, null: false
      t.string :skill_type_name, null: false
      t.integer :skill_type_id, default: 0, null: false
      t.integer :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
