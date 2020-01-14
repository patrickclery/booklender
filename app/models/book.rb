class Book < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :created_at

  validates_uniqueness_of :title

  has_many :transactions
end
