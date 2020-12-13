# frozen_string_literal: true

# class_type: Model
# class_name: Project
class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :contract, optional: true
  has_many :mid_positions
  has_many :positions, through: :mid_positions
  has_many :mid_tags
  has_many :tags, through: :mid_tags
  has_many :mid_industries
  has_many :industries, through: :mid_industries

  validates :title, :company_id, :company, :url, :display_flg, :deleted_flg, presence: true
  validates :display_flg, :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # single project data
  scope :single_project,  ->(pjt_id) {
    project_select.
      project_list_left_outer_joins.
      find_by(id: pjt_id, display_flg: 0, deleted_flg: 0, deleted_at: nil)
  }

  # project list(sort)
  scope :project_list, ->(sort, offset) {
    project_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      project_list_accessories(sort, offset)
  }

  # search by all types
  scope :project_list_search_all_types, ->(sort, offset, search_hash) {
    project_list.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_hash[:location_list]).
      where_contract_id_in(search_hash[:contract_list]).
      where_industry_id_in(search_hash[:industry_list]).
      where_positon_id_in(search_hash[:position_list]).
      where_tag_id_in(search_hash[:tag_list]).
      project_list_accessories(sort, offset)
  }

  scope :select_found_rows, -> do
    select('DISTINCT found_rows() AS total_pages')
  end

  # project select
  scope :project_select, -> do
    select(
      'SQL_CALC_FOUND_ROWS
       projects.*,
       locations.location_name,
       contracts.contract_name,
       GROUP_CONCAT(DISTINCT(positions.position_name)) AS position_name_list,
       GROUP_CONCAT(DISTINCT(positions.position_name_search)) AS position_name_search_list,
       GROUP_CONCAT(DISTINCT(industries.industry_name)) AS industry_name_list,
       GROUP_CONCAT(DISTINCT(industries.industry_name_search)) AS industry_name_search_list,
       GROUP_CONCAT(DISTINCT(tags.tag_name)) AS tag_name_list,
       GROUP_CONCAT(DISTINCT(tags.tag_name_search)) AS tag_name_search_list'
    )
  end

  # project list left outer joins
  scope :project_list_left_outer_joins, -> do
    left_joins(:location).
      left_joins(:contract).
      left_joins(:industries).
      left_joins(:positions).
      left_joins(:tags)
  end

  scope :where_project_id, ->(project_id) {
    where(id: project_id)
  }

  # WHERE location_id IN ()
  scope :where_location_id_in, ->(location_list) {
    where('locations.id IN (?)', location_list)
  }

  # WHERE contract_if IN ()
  scope :where_contract_id_in, ->(contract_list) {
    where('contracts.id IN (?)', contract_list)
  }

  # WHERE industry_id IN ()
  scope :where_industry_id_in, ->(industry_list) {
    where('industries.id IN (?)', industry_list)
  }

  # WHERE position_id IN ()
  scope :where_position_id_in, ->(position_list) {
    where('positions.id IN (?)', position_list)
  }

  # WHERE tag_id IN ()
  scope :where_tag_id_in, ->(tag_list) {
    where('tags.id IN (?)', tag_list)
  }

  scope :project_list_accessories, ->(sort, offset) {
    group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }
end
