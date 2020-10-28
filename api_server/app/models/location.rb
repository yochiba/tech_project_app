# frozen_string_literal: true

# class_type: Model
# class_name: Location
class Location < ApplicationRecord
  belongs_to :project

  validates :location_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }
end
