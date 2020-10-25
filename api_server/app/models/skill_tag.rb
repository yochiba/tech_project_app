# frozen_string_literal: true

# class_type: Model
# class_name: SkillTag
class SkillTag < ApplicationRecord

  # find existing skill_tag
  scope :search_existing_skill_tag, ->(skill_tag_name_search) {
    skill_tag_name_search_pattern = ActiveRecord::Base.send(:sanitize_sql_like, skill_tag_name_search)
    where('skill_tag_name_search LIKE ?', "%#{skill_tag_name_search_pattern}%").order(id: :desc).limit(1)
  }
end
