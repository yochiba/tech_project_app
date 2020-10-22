class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.integer :company_id, null: false
      t.string :url
      t.text :required_skills
      t.text :other_skills
      t.integer :weekly_attendance
      t.integer :min_operation_unit
      t.integer :max_operation_unit
      t.integer :operation_unit_id
      t.integer :min_price
      t.integer :max_price
      t.integer :price_unit_id
      t.integer :location_id
      t.integer :contract_id
      t.integer :position_id
      t.boolean :display_flg, default: 0, null: false
      t.boolean :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
