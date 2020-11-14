# frozen_string_literal: true

# class_type: Model
# class_name: Location
class Location < ApplicationRecord
  has_many :projects

  validates :location_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # find existing location
  scope :confirm_location, ->(location_name) {
    pattern = ActiveRecord::Base.send(:sanitize_sql_like, location_name)
    where('location_name LIKE ?', "%#{pattern}%").order(id: :desc).limit(1)
  }
end
