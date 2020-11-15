# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :tag_name, null: false
      t.string :tag_name_search, null: false
      t.string :tag_type_name, null: false, default: 'その他'
      t.integer :tag_type_id, null: false, deffault: 0
      t.integer :deleted_flg, null: false, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
