SELECT
  a.*,
  b.location_name,
  c.contract_name,
  d.industry_name,
  GROUP_CONCAT(distinct(f.tag_name)) AS tag_name,
  GROUP_CONCAT(distinct(f.tag_name_search)) AS tag_name_search,
  GROUP_CONCAT(distinct(h.position_name)) AS position_name,
  GROUP_CONCAT(distinct(h.position_name_search)) AS position_name_search
FROM
  projects a
LEFT OUTER JOIN
  locations b
ON
  a.location_id = b.id
LEFT OUTER JOIN
  contracts c
ON
  a.contract_id = c.id
LEFT OUTER JOIN
  industries d
ON
  a.industry_id = d.id
LEFT OUTER JOIN
  mid_tags e
ON
  a.id = e.project_id
LEFT OUTER JOIN
  tags f
ON
  e.tag_id = f.id
LEFT OUTER JOIN
  mid_positions g
ON
  a.id = g.project_id
LEFT OUTER JOIN
  positions h
ON
  g.position_id = h.id
WHERE
  a.display_flg = 0 AND
  a.deleted_flg = 0 AND
  a.deleted_at IS NULL
GROUP BY
  a.id
ORDER BY
  a.created_at DESC
LIMIT
  20
OFFSET
  80;