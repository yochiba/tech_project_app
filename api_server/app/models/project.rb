# frozen_string_literal: true

# class_type: Model
# class_name: Project
class Project < ApplicationRecord
  has_one :location
  has_one :position
  has_one :industry
  has_one :contract

  validates :title, :company_id, :company, :url, :display_flg, :deleted_flg, presence: true
  validates :display_flg, :deleted_flg, numericality: { greater_than_or_equal_to: 0 }
end
