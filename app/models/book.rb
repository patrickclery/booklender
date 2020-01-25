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

  def total_income(from: nil, to: nil)
    Book.total_income(title: title, author: author, from: from, to: to)
  end

  class << self

    def total_copies(title:, author:)
      where(title: title, author: author).count
    end

    def remaining_copies(title:, author:)
      # If any rows exist for the book in transactions where the `returned_at` is NULL, then it has yet to be returned. So only return where it's not null
      sql = <<SQL
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
      Book.find_by_sql([sql, { title: title, author: author }]).count
    end

    # @param String title
    # @param String author
    # @param DateTime from
    # @param DateTime to
    def total_income(title:, author:, from: nil, to: nil)

      params = {
        title:  title,
        author: author
      }

      sql = <<SQL
SELECT sum(amount_cents) AS total_income_cents
FROM
  transactions t
    LEFT JOIN books b ON b.id = t.book_id
WHERE
  b.title = :title AND
  b.author = :author
SQL

      # Insert date/time condition
      if from.present? and to.present?
        sql += ' AND t.created_at BETWEEN :from AND :to'
        params.merge!({ from: from, to: to })
      end

      sql += ' GROUP BY b.title, b.author'
      Book.find_by_sql([sql, params]).pluck(:total_income_cents).first
    end

    def find_all_by_date(from: nil, to: nil)
      # If any rows exist for the book in transactions where the `returned_at` is NULL, then it has yet to be returned. So only return where it's not null
      sql = <<SQL
SELECT
  -- need this distinct since the counts as
  DISTINCT ON (title, author)
  id,
  title, author,
  copies_count,
  COALESCE(loans_count, 0) AS loans_count,
  (copies_count - COALESCE(loans_count, 0)) AS remaining_count,
  COALESCE(total_income, 0) AS total_income
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
SQL

      params = {}
      # Insert date/time condition
      if from.present? and to.present?
        sql += ' AND t.created_at BETWEEN :from AND :to'
        params.merge!({ from: from, to: to })
      end

sql += <<SQL
    returned_at IS NULL
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
SQL

      # Insert date/time condition
      if from.present? and to.present?
        sql += <<SQL
WHERE
  transactions.created_at BETWEEN :from AND :to
SQL
      end

      sql += <<SQL
  GROUP BY (title, author)
) books_total_3 USING (title,author)
SQL

      Book.find_by_sql([sql, params])
    end

    # @param String title
    # @param String author
    # @param DateTime from
    # @param DateTime to
    def total_income(title:, author:, from: nil, to: nil)

      params = {
        title:  title,
        author: author
      }

      sql = <<SQL
SELECT sum(amount_cents) AS total_income_cents
FROM
  transactions t
    LEFT JOIN books b ON b.id = t.book_id
WHERE
  b.title = :title AND
  b.author = :author
SQL

      # Insert date/time condition
      if from.present? and to.present?
        sql += ' AND t.created_at BETWEEN :from AND :to'
        params.merge!({ from: from, to: to })
      end

      sql += ' GROUP BY b.title, b.author'
      Book.find_by_sql([sql, params]).pluck(:total_income_cents).first
    end

  end

end
