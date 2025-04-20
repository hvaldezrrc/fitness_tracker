class WorkoutsController < ApplicationController
  def show
    @workout = Workout.includes(:user, :workout_exercises, :exercises).find(params[:id])
    @exercises = @workout.exercises
  end
end
