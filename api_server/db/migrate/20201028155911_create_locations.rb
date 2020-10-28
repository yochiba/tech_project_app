# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :location_name, null: false
      t.integer :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
