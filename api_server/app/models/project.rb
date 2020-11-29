# frozen_string_literal: true

# class_type: Model
# class_name: Project
class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :industry, optional: true
  belongs_to :contract, optional: true
  has_many :mid_positions
  has_many :mid_tags

  validates :title, :company_id, :company, :url, :display_flg, :deleted_flg, presence: true
  validates :display_flg, :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # project list(sort: latest)
  scope :project_list_latest, ->(offset) {
    where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      left_joins(:location).where(deleted_flg: 0, deleted_at: nil).
      left_joins(:contract).where(deleted_flg: 0, deleted_at: nil).
      left_joins(:industry).where(deleted_flg: 0, deleted_at: nil).
      order(created_at: :desc).
      limit(Settings.pjt_list_count).
      offset(offset).
      select('projects.*', 'locations.location_name', 'contracts.contract_name', 'industries.industry_name')
  }

  # project list(sort: price)
  scope :project_list_price, ->(offset) {
    where(display_flg: 0, deleted_flg: 0, deleted_at: nil).
      left_joins(:location).where(deleted_flg: 0, deleted_at: nil).
      left_joins(:contract).where(deleted_flg: 0, deleted_at: nil).
      left_joins(:industry).where(deleted_flg: 0, deleted_at: nil).
      order(price: :desc).
      limit(Settings.pjt_list_count).
      offset(offset).
      select('projects.*', 'locations.location_name', 'contracts.contract_name', 'industries.industry_name')
  }
end
