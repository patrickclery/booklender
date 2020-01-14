class User < ApplicationRecord
  has_many :transactions

  validates_presence_of :account_number
  validates_presence_of :created_at
  validates_presence_of :name

end
