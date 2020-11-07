# frozen_string_literal: true

# class_type: Model
# class_name: Position
class Position < ApplicationRecord
  validates :position_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }
end
