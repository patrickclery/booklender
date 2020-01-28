class Book < ApplicationRecord
  has_many :transactions

  attribute :total_income_cents
  attribute :remaining_copies_count
  attribute :copies_count

  validates_presence_of :title
  validates_presence_of :author

  def total_copies
    extended_details.copies_count
  end

  def remaining_copies
    extended_details.remaining_copies_count
  end

  def total_income(from: nil, to: nil)
    extended_details(from: from, to: to).total_income_cents
  end

  def extended_details(from: nil, to: nil)
    # Add a ||= in-case someone calls .total_income then .remaining_copies
    @details ||= Book.extended_details(from: from, to: to, title: title, author: author).first
  end

  class << Book

    # @param String title
    # @param String author
    # @param DateTime from
    # @param DateTime to
    def extended_details(from: nil, to: nil, title: nil, author: nil)
      params = {}
      # If any rows exist for the book in transactions where the `returned_at` is NULL, then it has yet to be returned. So only return where it's not null
      sql = <<SQL
SELECT
  -- need this distinct since the counts as
  DISTINCT ON (title, author)
  id,
  title, author,
  copies_count,
  COALESCE(loans_count, 0) AS loaned_copies_count,
  (copies_count - COALESCE(books_total_2.loans_count, 0)) AS remaining_copies_count,
  COALESCE(books_total_3.total_income, 0) AS total_income_cents
FROM
  books books_details
JOIN (
  --- Books available (a list of all books)
  SELECT
    title,
    author,
    count(*) AS copies_count
  FROM
    books
  GROUP BY (title, author)
  ) books_available USING (title,author)

LEFT JOIN (
  --- Books available (a list of books loaned), join it or return null
  SELECT
    title,
    author,
    count(*) AS loans_count
  FROM
    books AS books_total_1
      JOIN transactions ON transactions.book_id = books_total_1.id
WHERE
    returned_at IS NULL
SQL

      # Insert date/time condition
      if from.present? and to.present?
        sql += <<SQL
 AND transactions.created_at BETWEEN :from AND :to
SQL
        params.merge!({ from: from, to: to })
      end

      sql += <<SQL
  GROUP BY (title, author)
) books_total_2 USING (title,author)

--- Grabs the total income
LEFT JOIN (
  SELECT
    title,
    author,
    sum(amount_cents) AS total_income
  FROM
    books
  JOIN transactions ON transactions.book_id = books.id
  -- the next line is just to allow use of ' AND' in the next block 
  WHERE TRUE
SQL


      # Insert date/time condition
      if from.present? and to.present?
        sql += <<SQL
 AND
    transactions.created_at BETWEEN :from AND :to
SQL
      end

      sql += <<SQL
  GROUP BY (title, author)
) books_total_3 USING (title,author)
SQL

      if title.present? and author.present?
        sql += <<SQL
 WHERE
  books_details.title = :title AND
  books_details.author = :author
SQL
        params.merge!({ title: title, author: author })
      end

      Book.find_by_sql([sql, params])

    end

  end
end