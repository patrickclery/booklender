class Transaction < ApplicationRecord

  RENTAL_FEE = 25

  monetize :amount_cents

  belongs_to :book, required: true
  belongs_to :user, required: true

  validates_presence_of :amount_cents
  validates_presence_of :book
  validates_presence_of :user

  def initialize(*args)
    super(*args)
    self.amount_cents = RENTAL_FEE
  end
end
