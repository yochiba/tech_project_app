class CreateMidSkillTags < ActiveRecord::Migration[6.0]
  def change
    create_table :mid_skill_tags do |t|
      t.references :project, null: false
      t.references :skill_tag, null: false
      t.boolean :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
