# frozen_string_literal: true

# class_type: Model
# class_name: Industry
class Industry < ApplicationRecord
  has_many :projects, through: :mid_industries

  validates :industry_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # select id from industries
  scope :select_industry_id, ->(industry_name_search) {
    select(:id).
      where('industries.industry_name_search LIKE ?', "%#{industry_name_search}%").
      where(deleted_flg: 0, deleted_at: nil)
  }

  # select industry list
  scope :select_industries, -> do
    select(:id, :industry_name, :industry_name_search).
      where(deleted_flg: 0, deleted_at: nil)
  end
end
