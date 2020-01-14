class Transaction < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :book, required: true

  validates_presence_of :created_at
  validates_presence_of :user
  validates_presence_of :book

  monetize :amount_cents
end
