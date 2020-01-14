class User < ApplicationRecord
  validates_numericality_of :balance

  validates_presence_of :account_number
  validates_presence_of :balance
  validates_presence_of :name

  monetize :balance
end
