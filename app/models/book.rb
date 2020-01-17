class Book < ApplicationRecord
  has_many :transactions

  validates_presence_of :title
  validates_presence_of :author

  def total_copies
    Book.total_copies(title: title, author: author)
  end

  class << self
    def total_copies(title:, author:)
      where(title: title, author: author).count
    end
  end


end
