class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.page(params[:page]).per(30)
  end

  def show
    @exercise = Exercise.includes(workouts: :user).find(params[:id])
  end
end
