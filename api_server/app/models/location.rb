# frozen_string_literal: true

# class_type: Model
# class_name: Location
class Location < ApplicationRecord
  has_many :projects

  validates :location_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # select id from locations
  scope :select_location_id, ->(location_name) {
    select(:id).
      where('locations.location_name LIKE ?', "%#{location_name}%").
      where(deleted_flg: 0, deleted_at: nil)
  }

  # select location list
  scope :select_locations, -> do
    select(:id, :location_name).
      where(deleted_flg: 0, deleted_at: nil)
  end
end
