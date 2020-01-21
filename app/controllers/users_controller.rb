class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :loaned_books]

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  def loaned_books
    render json: @user.as_json(include: :loaned_books)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:id, :name, :account_number, :balance_cents)
  end
end
