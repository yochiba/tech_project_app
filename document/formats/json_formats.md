# json formats

## create_json
```
"create_json": {
            "create_json": {
                "company": "string",
                "company_id": integer,
                "url": "string",
                "title": "string",
                "description": "string",
                "required_skills": "string",
                "other_skills": "string",
                "price_unit_id": integer,
                "price_unit": "string",
                "min_price": integer,
                "max_price": integer,
                "min_operation_unit": integer,
                "max_operation_unit": integer,
                "operation_unit_id": integer,
                "operation_unit": "string",
                "weekly_attendance": integer,
                "location_id": integer,
                "industry_id": integer,
                "contract_id": integer
            },
            "error_project": "boolean",
            "location_name": "string",
            "position_array": [
                {
                    "position_name": "string",
                    "position_name_search": "string",
                    "position_id": "integer"
                }
            ],
            "industry_name": "string",
            "contract_name": "string",
            "tag_array": [
                {
                    "tag_type_name": "string",
                    "tag_type_id": "integer",
                    "tag_name": "string",
                    "tag_name_search": "string",
                    "tag_id": "integer"
                }
            ]
        }
```

## search query
```
{
  "keywords": ["string"],
  "tags": {
      "language": ["string"],
      "framework": ["string"],
      "db": ["string"],
      "tool": ["string"],
      "os": ["string"],
      "package": ["string"],
      "rpa": ["string"],
      "other": ["string"]
  },
  "price": {
      "min_price": "integer",
      "max_price": "integer"
  },
  "location": ["string"],
  "position": ["string"],
  "industry": ["string"],
  "contract": ["string"]
}
```
