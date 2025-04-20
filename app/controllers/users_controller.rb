class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @workouts = @user.workouts
    @meal_logs = @user.meal_logs
    @progress_entries = @user.progress_entries
  end
end
