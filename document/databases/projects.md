# projects

- ## description
  the table for projects

***

- ## table architecture
|#|name|data_type|japanese_name|null|default|description|
|-:|:-|:-|:-|:-|:-|:-|
|1|id|integer|ID|NO||auto increment|
|2|title|string|案件タイトル|NO|||
|3|description|text|説明|YES|||
|4|company_id|integer|企業ID|NO||データ取得元企業|
|5|required_skills|text|必須スキル|YES|||
|6|other_skills|text|その他スキル|YES|||
|7|weekly_attendance|integer|出勤回数(日/週)|YES|||
|8|min_operation_unit|integer|最低稼働|YES|||
|9|max_operation_unit|integer|最大稼働|YES|||
|10|operation_unit_id|integer|稼働単位ID|NO|||
|11|min_price|integer|最小単価|YES||単位は円|
|12|max_price|integer|最大単価|YES||単位は円|
|13|price_unit_id|integer|単価単位ID|YES|||
|14|location_id|integer|ロケーションID|YES|||
|15|contract_id|integer|契約形態ID|YES|||
|16|position_id|integer|ポジションID|YES|||
|17|url|string|案件URL|NO|||
|18|deleted_flg|boolean|削除フラグ|NO|0|0:未削除, 1:削除<br>論理削除で30日が経過したら削除|
|19|deleted_at|date|削除日時|YES|||
|20|display_flg|integer|表示フラグ|NO|0|0:表示, 1:非表示|
|21|created_at|date|作成日時|NO|||
|22|updated_at|date|更新日時|NO|||

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