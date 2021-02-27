# frozen_string_literal: true

# class_type: Model
# class_name: Position
class Position < ApplicationRecord
  has_many :projects, through: :mid_positions

  validates :position_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # select id from positions
  scope :select_position_id, ->(position_name_search) {
    select(:id).
      where('positions.position_name_search LIKE ?', "%#{position_name_search}%").
      where(deleted_flg: 0, deleted_at: nil)
  }

  # select position list
  scope :select_positions, -> do
    select(:id, :position_name, :position_name_search).
      where(deleted_flg: 0, deleted_at: nil).
      order(updated_at: :desc)
  end
end
