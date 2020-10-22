# skill_tags

- ## description
  the database master table for skill tag

- ## model
```
class CreateSkillTags < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_tags do |t|
      t.string :skill_name, null: false
      t.text :description
      t.integer :skill_type_id, null: false
      t.boolean :deleted_flg, default: 0, null: false
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
|2|skill_name|string|スキル名称|NO|||
|3|description|text|スキル説明|YES|||
|4|skill_type_id|integer|スキルタイプ|NO|0|スキルのタイプを格納<br>0:言語, 1:フレームワーク, 2:DB, 3:ツール|
|5|deleted_flg|boolean|削除フラグ|NO|0|0:未削除, 1:削除<br>論理削除で30日が経過したら削除|
|6|deleted_at|date|削除日時|YES|||
|7|created_at|date|作成日時|NO|||
|8|updated_at|date|更新日時|NO|||

***

- ## foreign keys
|name|table name|japanese name|description|
|:-|:-|:-|:-|