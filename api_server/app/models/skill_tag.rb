# frozen_string_literal: true

# class_type: Model
# class_name: SkillTag
class SkillTag < ApplicationRecord
  validates :skill_tag_name, :skill_tag_name_search, :skill_type_id, :deleted_flg, presence: true
  validates :skill_type_id, :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # find existing skill_tag
  scope :search_existing_skill_tag, ->(skill_tag_name_search) {
    pattern = ActiveRecord::Base.send(:sanitize_sql_like, skill_tag_name_search)
    where('skill_tag_name_search LIKE ?', "%#{pattern}%").order(id: :desc).limit(1)
  }
end
