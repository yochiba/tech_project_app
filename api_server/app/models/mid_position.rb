# frozen_string_literal: true

# class_type: Model
# class_name: MidPosition
class MidPosition < ApplicationRecord
  belongs_to :projects, optional: true

  validates :project_id, :position_id, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }
end
