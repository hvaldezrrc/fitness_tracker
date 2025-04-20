class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all
  end

  def show
    @exercises = Exercise.find(params[:id])
  end
end
