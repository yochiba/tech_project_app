# frozen_string_literal: true

class CreateMidPositions < ActiveRecord::Migration[6.0]
  def change
    create_table :mid_positions do |t|
      t.references :project, null: false
      t.references :position, null: false
      t.integer :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end