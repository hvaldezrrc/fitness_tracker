class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all
  end

  def show
    @exercises = Exercise.includes(workouts: :user).find(params[:id])
  end
end
