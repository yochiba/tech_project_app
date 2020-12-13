class CreateMidIndustries < ActiveRecord::Migration[6.0]
  def change
    create_table :mid_industries do |t|
      t.references :project, null: false
      t.references :industry, null: false
      t.integer :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
