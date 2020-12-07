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
  scope :project_list, ->(sort, offset) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      project_list_accessories(sort, offset)
  }

  # search by all tags([0, 1, 2, 3])
  scope :project_list_search_all_tags, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_hash[:location_list]).
      where_contract_id_in(search_hash[:contract_list]).
      where_industry_id_in(search_hash[:industry_list]).
      where_tag_id_in(search_hash[:tag_list]).
      project_list_accessories(sort, offset)
  }

  # location, contract, industry([0, 1, 2])
  scope :project_list_search_location_contract_industry, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_hash[:location_list]).
      where_contract_id_in(search_hash[:contract_list]).
      where_industry_id_in(search_hash[:industry_list]).
      project_list_accessories(sort, offset)
  }

  # location, contract, industry([1, 2, 3])
  scope :project_list_search_contract_industry_tag, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_contract_id_in(search_hash[:contract_list]).
      where_industry_id_in(search_hash[:industry_list]).
      where_tag_id_in(search_hash[:tag_list]).
      project_list_accessories(sort, offset)
  }

  # location, industry, tag([0, 2, 3])
  scope :project_list_search_location_industry_tag, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_hash[:location_list]).
      where_industry_id_in(search_hash[:industry_list]).
      where_tag_id_in(search_hash[:tag_list]).
      project_list_accessories(sort, offset)
  }

  # location, contract, tag([0, 1, 3])
  scope :project_list_location_contract_tag, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_hash[:location_list]).
      where_contract_id_in(search_hash[:contract_list]).
      where_tag_id_in(search_hash[:tag_list]).
      project_list_accessories(sort, offset)
  }

  # location, contract([0, 1])
  scope :project_list_search_location_contract, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_hash[:location_list]).
      where_contract_id_in(search_hash[:contract_list]).
      project_list_accessories(sort, offset)
  }

  # contract, industry([1, 2])
  scope :project_list_search_contract_industry, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_contract_id_in(search_hash[:contract_list]).
      where_industry_id_in(search_hash[:industry_list]).
      project_list_accessories(sort, offset)
  }

  # industry, tag([2, 3])
  scope :project_list_search_industry_tag, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_industry_id_in(search_hash[:industry_list]).
      where_tag_id_in(search_hash[:tag_list]).
      project_list_accessories(sort, offset)
  }

  # location, tag([0, 3])
  scope :project_list_search_location_tag, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_contract_id_in(search_hash[:contract_list]).
      where_industry_id_in(search_hash[:industry_list]).
      project_list_accessories(sort, offset)
  }

  # location([0])
  scope :project_list_search_location, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_location_id_in(search_hash[:location_list]).
      project_list_accessories(sort, offset)
  }

  # contract([1])
  scope :project_list_search_contract, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_contract_id_in(search_hash[:contract_list]).
      project_list_accessories(sort, offset)
  }

  # industry([2])
  scope :project_list_search_industry, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_industry_id_in(search_hash[:industry_list]).
      project_list_accessories(sort, offset)
  }

  # tag([3])
  scope :project_list_search_tag, ->(sort, offset, search_hash) {
    project_list_select.
      project_list_left_outer_joins.
      where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      where_tag_id_in(search_hash[:tag_list]).
      project_list_accessories(sort, offset)
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

  scope :project_list_accessories, ->(sort, offset) {
    group('projects.id').
      order(sort).
      limit(Settings.pjt_list_count).
      offset(offset)
  }
end
