class CreateSkillTags < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_tags do |t|
      t.string :skill_name, null: false
      t.text :description
      t.integer :skill_type_id, null: false
      t.boolean :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
