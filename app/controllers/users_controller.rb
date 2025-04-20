class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @workouts = @user.workouts.page(params[:page]).per(5)
    @meal_logs = @user.meal_logs.page(params[:page]).per(5)
    @progress_entries = @user.progress_entries
  end
end
