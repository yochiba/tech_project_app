class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.string :position_name, null: false
      t.integer :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
