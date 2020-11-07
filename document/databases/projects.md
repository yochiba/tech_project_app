# projects

- ## description
  the table for projects

- ## model
```
# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.integer :company_id, null: false
      t.string :company, null: false
      t.string :url
      t.text :required_skills
      t.text :other_skills
      t.integer :weekly_attendance
      t.integer :min_operation_unit
      t.integer :max_operation_unit
      t.integer :operation_unit_id
      t.string :operation_unit
      t.integer :min_price
      t.integer :max_price
      t.integer :price_unit_id
      t.string :price_unit
      t.integer :location_id
      t.string :location
      t.integer :contract_id
      t.string :contract
      t.integer :position_id
      t.string :position
      t.integer :display_flg, default: 0, null: false
      t.integer :deleted_flg, default: 0, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end

```

***

- ## table architecture
|#|name|data_type|japanese_name|null|default|description|
|-:|:-|:-|:-|:-|:-|:-|
|1|id|integer|ID|NO||auto increment|
|2|title|string|案件タイトル|NO|||
|3|description|text|説明|YES|||
|4|company_id|integer|企業ID|NO||データ取得元企業ID|
|5|company|string|企業|NO||データ取得元企業|
|6|url|string|案件URL|NO|||
|7|required_skills|text|必須スキル|YES|||
|8|other_skills|text|その他スキル|YES|||
|9|weekly_attendance|integer|出勤回数(日/週)|YES|||
|10|min_operation_unit|integer|最低稼働|YES|||
|11|max_operation_unit|integer|最大稼働|YES|||
|12|operation_unit_id|integer|稼働単位ID|YES|||
|13|operation_unit|string|稼働単位|YES|||
|14|min_price|integer|最小単価|YES||単位は円|
|15|max_price|integer|最大単価|YES||単位は円|
|16|price_unit_id|integer|単価単位ID|YES|||
|17|location_id|integer|ロケーションID|YES|||
|18|contract_id|integer|契約形態ID|YES|||
|19|industry_id|integer|業界ID|YES|||
|20|display_flg|integer|表示フラグ|NO|0|0:表示, 1:非表示|
|21|deleted_flg|integer|削除フラグ|NO|0|0:未削除, 1:削除<br>論理削除で30日が経過したら削除|
|22|deleted_at|date|削除日時|YES|||
|23|created_at|date|作成日時|NO|||
|24|updated_at|date|更新日時|NO|||

***

- ## foreign keys
|name|table name|japanese name|description|
|:-|:-|:-|:-|
|operate_hour_unit_id|integer|稼働時間単位||
|price_unit_id|integer|単価単位||
|location_id|integer|ロケーションID||
|contract_id|integer|契約形態ID||
|position_id|integer|ポジションID||

master DBの要否は要検討