# positions

- ## description
  the database master table for positions

- ## model
```
# frozen_string_literal: true

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


```

***

- ## table architecture
|#|name|data_type|japanese_name|null|default|description|
|-:|:-|:-|:-|:-|:-|:-|
|1|id|integer|ID|NO||auto increment|
|2|position_name|string|ポジション名称|NO|||
|3|deleted_flg|integer|削除フラグ|NO|0|0:未削除, 1:削除<br>論理削除で30日が経過したら削除|
|4|deleted_at|date|削除日時|YES|||
|5|created_at|date|作成日時|NO|||
|6|updated_at|date|更新日時|NO|||

***

- ## foreign keys
|name|table name|japanese name|description|
|:-|:-|:-|:-|