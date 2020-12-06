# frozen_string_literal: true

# class_type: Model
# class_name: Contract
class Contract < ApplicationRecord
  has_many :projects

  validates :contract_name, :deleted_flg, presence: true
  validates :deleted_flg, numericality: { greater_than_or_equal_to: 0 }

  # select id from contracts
  scope :select_contract_id, ->(contract_name) {
    select(:id).
      where('contracts.contract_name LIKE ?', "%#{contract_name}%").
      where(deleted_flg: 0, deleted_at: nil)
  }
end
