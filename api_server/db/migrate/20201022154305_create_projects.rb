# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false, comment: '案件タイトル'
      t.text :description, comment: '案件説明'
      t.integer :company_id, null: false, comment: '案件掲載企業ID'
      t.string :company, null: false, comment: '案件掲載企業名'
      t.string :url, null: false, default: '', comment: '案件URL'
      t.text :required_skills, comment: '必須スキル'
      t.text :other_skills, comment: '尚可スキル'
      t.text :environment, comment: '開発環境'
      t.integer :weekly_attendance, comment: '出勤日数/週'
      t.integer :min_operation_unit, null: false, default: 0, comment: '最低稼働時間'
      t.integer :max_operation_unit, null: false, default: 0, comment: '最高稼働時間'
      t.integer :operation_unit_id, comment: '稼働時間単位ID'
      t.string :operation_unit, comment: '稼働時間単位'
      t.integer :min_price, null: false, default: 0, comment: '最低単価'
      t.integer :max_price, null: false, default: 0, comment: '最高単価'
      t.integer :price_unit_id, comment: '単価単位ID'
      t.string :price_unit, comment: '単価単位'
      t.references :location, comment: '勤務地'
      t.references :contract, comment: '契約形態'
      t.integer :display_flg, null: false, default: 0
      t.integer :deleted_flg, null: false, default: 0, comment: '削除フラグ'
      t.datetime :deleted_at, comment: '削除日時'

      t.timestamps
    end
  end
end
