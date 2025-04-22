class WorkoutsController < ApplicationController
  def index
    @workouts = Workout.includes(:user)
    @users = User.all

    if params[:search].present?
      @workouts = @workouts.where("name LIKE ?", "%#{params[:search]}%")
    end

    if params[:user_id].present? && params[:user_id] != ""
      @workouts = @workouts.where(user_id: params[:user_id])
    end

    @workouts = @workouts.page(params[:page]).per(10)
  end
  def show
    @workout = Workout.includes(:user, :workout_exercises, :exercises).find(params[:id])
    @exercises = @workout.exercises
  end
end
