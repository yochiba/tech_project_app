# frozen_string_literal: true

# class_type: Model
# class_name: Contract
class Contract < ApplicationRecord
  has_many :projects

  validates :contract_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # find existing contract
  scope :confirm_contract, ->(contract_name) {
    pattern = ActiveRecord::Base.send(:sanitize_sql_like, contract_name)
    where('contract_name LIKE ?', "%#{pattern}%").order(id: :desc).limit(1)
  }
end
