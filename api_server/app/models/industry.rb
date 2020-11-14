# frozen_string_literal: true

# class_type: Model
# class_name: Industry
class Industry < ApplicationRecord
  has_many :projects

  validates :industry_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # find existing industry
  scope :confirm_industry, ->(industry_name) {
    pattern = ActiveRecord::Base.send(:sanitize_sql_like, industry_name)
    where('industry_name LIKE ?', "%#{pattern}%").order(id: :desc).limit(1)
  }
end
