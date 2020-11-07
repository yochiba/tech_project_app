# frozen_string_literal: true

# class_type: Model
# class_name: Project
class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :industry, optional: true
  belongs_to :contract, optional: true
  has_many :mid_positions
  has_many :mid_skill_tags

  validates :title, :company_id, :company, :url, :display_flg, :deleted_flg, presence: true
  validates :display_flg, :deleted_flg, numericality: { greater_than_or_equal_to: 0 }
end
