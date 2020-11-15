# tags

- ## description
  the database master table for skill tag

- ## model
```
# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :tag_name, null: false
      t.string :tag_name_search, null: false
      t.string :tag_type_name, null: false, default: 'その他'
      t.integer :tag_type_id, null: false
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
|2|tag_name|string|タグ名称|NO|||
|3|tag_name_search|string|タグ名称検索用|NO||全角大文字で登録|
|4|tag_type_name|string|タグタイプ名称|NO|||
|5|tag_type_id|integer|タグタイプ|NO|0|スキルのタイプを格納|
|6|deleted_flg|integer|削除フラグ|NO|0|0:未削除, 1:削除<br>論理削除で30日が経過したら削除|
|7|deleted_at|date|削除日時|YES|||
|8|created_at|date|作成日時|NO|||
|9|updated_at|date|更新日時|NO|||

***

- ## foreign keys
|name|table name|japanese name|description|
|:-|:-|:-|:-|