# frozen_string_literal: true

# class_type: Model
# class_name: Project
class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :industry, optional: true
  belongs_to :contract, optional: true
  has_many :mid_positions
  has_many :positions, through: :mid_positions
  has_many :mid_tags
  has_many :tags, through: :mid_tags

  validates :title, :company_id, :company, :url, :display_flg, :deleted_flg, presence: true
  validates :display_flg, :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # project list(sort)
  scope :project_list, ->(offset, sort) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  # search by all tags
  scope :project_list_search_all_tags, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_query[:location_list]).
      where_contract_id_in(search_query[:contract_list]).
      where_industry_id_in(search_query[:industry_list]).
      where_tag_id_in(search_query[:tag_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_location_contract_industry, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_query[:location_list]).
      where_contract_id_in(search_query[:contract_list]).
      where_industry_id_in(search_query[:industry_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_location_contract_tag, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_query[:location_list]).
      where_contract_id_in(search_query[:contract_list]).
      where_tag_id_in(search_query[:tag_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_location_industry_tag, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_query[:location_list]).
      where_industry_id_in(search_query[:industry_list]).
      where_tag_id_in(search_query[:tag_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_contract_industry_tag, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_contract_id_in(search_query[:contract_list]).
      where_industry_id_in(search_query[:industry_list]).
      where_tag_id_in(search_query[:tag_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_location_contract, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_query[:location_list]).
      where_contract_id_in(search_query[:contract_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_location_tag, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_query[:location_list]).
      where_tag_id_in(search_query[:tag_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_industry_tag, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_industry_id_in(search_query[:industry_list]).
      where_tag_id_in(search_query[:tag_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_contract_industry, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_contract_id_in(search_query[:contract_list]).
      where_industry_id_in(search_query[:industry_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_location, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_query[:location_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_tag, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_tag_id_in(search_query[:tag_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_industry, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_industry_id_in(search_query[:industry_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  scope :project_list_search_contract, ->(offset, sort, search_query) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_contract_id_in(search_query[:contract_list]).
      group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }

  # project list select
  scope :project_list_select, -> do
    select(
      'projects.*,
      locations.location_name,
      contracts.contract_name,
      industries.industry_name,
      GROUP_CONCAT(DISTINCT(positions.position_name)) AS position_name_list,
      GROUP_CONCAT(DISTINCT(positions.position_name_search)) AS position_name_search_list,
      GROUP_CONCAT(DISTINCT(tags.tag_name)) AS tag_name_list,
      GROUP_CONCAT(DISTINCT(tags.tag_name_search)) AS tag_name_search_list'
    )
  end

  # project list left outer joins
  scope :project_list_left_outer_joins, -> do
    left_joins(:location).
      left_joins(:contract).
      left_joins(:industry).
      left_joins(:positions).
      left_joins(:tags)
  end

  # WHERE location_name LIKE '%string%'
  # scope :where_location_name_like, ->(location_list) {
  #   location_list.map { |location_name|
  #     where('locations.location_name LIKE ?', "%#{location_list}%")
  #   }
  # }

  # WHERE contract_name LIKE '%string%'
  # scope :where_contract_name_like, ->(contract_list) {
  #   contract_list.map { |contract_name|
  #     where('contracts.contract_name LIKE ?', "%#{contract_name}%")
  #   }
  # }

  # WHERE industry_name LIKE '%string%'
  # scope :where_industry_name_like, ->(industry_list) {
  #   industry_list.map { |industry_name|
  #     where('industries.industry_name LIKE ?', "%#{industry_name}%")
  #   }
  # }

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

  # WHERE tag_id IN ()
  scope :where_tag_id_in, ->(tag_list) {
    where('tags.id IN (?)', tag_list)
  }
end
