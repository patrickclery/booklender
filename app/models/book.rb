class Book < ApplicationRecord
  has_many :transactions

  validates_presence_of :created_at
  validates_presence_of :title
  validates_uniqueness_of :title

end
