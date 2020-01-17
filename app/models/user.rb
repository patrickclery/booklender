class User < ApplicationRecord
  has_many :transactions
  has_many :books, -> { where(returned_at: nil) }, through: :transactions
  has_many :books_history, class_name: 'Book', through: :transactions

  validates_presence_of :account_number
  validates_presence_of :balance_cents
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :account_number

  monetize :balance_cents

end
