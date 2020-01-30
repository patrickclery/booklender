class BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy, :income]

  # 3. Query the account of a user and the details of the current borrowed book, The parameter is the user.
  def index
    @books = Book.extended_details

    render json: @books.as_json(
      only: [:id, :title, :author, :created_at, :total_income_cents, :copies_count, :remaining_copies_count, :loaned_copies_count]
    )
  end

  def show
    render json: @book.extended_details.as_json(
      only: [:id, :title, :author, :created_at, :total_income_cents, :copies_count, :remaining_copies_count, :loaned_copies_count]
    )
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:id, :title, :author, :from, :to)
  end
end
