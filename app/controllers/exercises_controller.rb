class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.page(params[:page]).per(10)
  end

  def show
    @exercises = Exercise.includes(workouts: :user).find(params[:id])
  end
end
