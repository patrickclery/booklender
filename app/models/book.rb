class Book < ApplicationRecord
  has_many :transactions

  validates_presence_of :title
  validates_presence_of :author

end
