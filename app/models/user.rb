class User < ApplicationRecord
  has_many :transactions

  # Books
  has_many :books, -> { order('transactions.created_at') },
           through: :transactions, source: :book
  has_many :loaned_books, -> { where(returned_at: nil).order('transactions.created_at') },
           through: :transactions,
           source:  :book
  has_many :returned_books, -> { where.not(returned: nil).order('transactions.returned_at') },
           through: :transactions,
           source:  :book

  validates_presence_of :account_number
  validates_presence_of :balance_cents
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :account_number

  monetize :balance_cents

end
