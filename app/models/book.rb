class Book < ApplicationRecord
  has_many :transactions

  validates_presence_of :title
  validates_presence_of :author

  def total_copies
    Book.total_copies(title: title, author: author)
  end

  def remaining_copies
    Book.remaining_copies(title: title, author: author)
  end

  class << self

    def total_copies(title:, author:)
      where(title: title, author: author).count
    end

    def remaining_copies(title:, author:)
      # If any rows exist for the book in transactions where the `returned_at` is NULL, then it has yet to be returned. So only return where it's not null
      sql =<<SQL
SELECT *
FROM books b
WHERE
  NOT EXISTS(
    SELECT 1
    FROM transactions t
    WHERE
      t.book_id = b.id AND
      b.title = :title AND
      b.author = :author AND
      t.returned_at IS NULL
    )
SQL
      Book.find_by_sql([sql, {title: title, author: author}]).count
    end

  end

end
