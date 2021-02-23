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

  validates :title, :company_id, :company, :url, :affiliate_url, :min_operation_unit, :display_flg,
            :max_operation_unit, :min_price, :max_price, :deleted_flg, presence: true
  validates :display_flg, :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # project
  scope :single_project,  ->(pjt_id) {
    select_option.
      project_list_left_outer_joins.
      find_by(id: pjt_id, display_flg: 0, deleted_flg: 0, deleted_at: nil)
  }

  # project list
  scope :project_list, -> {
    selects_option.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil)
  }

  scope :select_total_count, -> do
    select('count(*)')
  end

  # project select options
  scope :select_option, -> do
    select(
      'projects.*,
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

  # projects select options
  scope :selects_option, -> do
    select(
      'projects.id,
       projects.title,
       projects.company,
       projects.url,
       projects.min_price,
       projects.max_price,
       projects.price_unit,
       projects.updated_at,
       GROUP_CONCAT(DISTINCT(positions.position_name)) AS position_name_list,
       GROUP_CONCAT(DISTINCT(industries.industry_name)) AS industry_name_list,
       GROUP_CONCAT(DISTINCT(tags.tag_name)) AS tag_name_list'
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

  # WHERE project_id IN ()
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

  scope :sub_options, ->(sort_option, offset) {
    group('projects.id').
      order(sort_option).
      limit(Settings.pjt_list_count).
      offset(offset)
  }
end
