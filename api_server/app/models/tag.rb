class Tag < ApplicationRecord
  validates :tag_name, :tag_name_search, :tag_type_id, :deleted_flg, presence: true
  validates :tag_type_id, :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # find existing tag
  scope :search_existing_tag, ->(tag_name_search) {
    pattern = ActiveRecord::Base.send(:sanitize_sql_like, tag_name_search)
    where('tag_name_search LIKE ?', "%#{pattern}%").order(id: :desc).limit(1)
  }
end
