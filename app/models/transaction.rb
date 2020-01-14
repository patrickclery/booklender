class Transaction < ApplicationRecord
  belongs_to :book, required: true
  belongs_to :user, required: true

  monetize :amount_cents

  validates_presence_of :book
  validates_presence_of :created_at
  validates_presence_of :user

end
