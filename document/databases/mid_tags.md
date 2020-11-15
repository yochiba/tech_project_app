# mid_tags

- ## description
  the database middle table for skill tag

- ## model
```
# frozen_string_literal: true

class CreateMidTags < ActiveRecord::Migration[6.0]
  def change
    create_table :mid_tags do |t|
      t.references :project, null: false
      t.references :tag, null: false
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
|2|project_id|integer|案件ID|NO|||
|3|tag_id|integer|タグID|NO|||
|4|deleted_flg|integer|削除フラグ|NO|0|0:未削除, 1:削除<br>論理削除で30日が経過したら削除|
|5|deleted_at|date|削除日時|YES|||
|6|created_at|date|作成日時|NO|||
|7|updated_at|date|更新日時|NO|||

***

- ## foreign keys
|name|table name|japanese name|description|
|:-|:-|:-|:-|
|project_id|integer|案件ID||
|tag_id|integer|タグID||
