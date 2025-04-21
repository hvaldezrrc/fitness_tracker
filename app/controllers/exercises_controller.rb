class ExercisesController < ApplicationController
  def index
    if params[:search].present?
      @exercises = Exercise.where("name LIKE ? OR target_muscle LIKE ? OR exercise_type LIKE ?",
                                 "%#{params[:search]}%",
                                 "%#{params[:search]}%",
                                 "%#{params[:search]}%")
                          .page(params[:page]).per(10)
    else
      @exercises = Exercise.page(params[:page]).per(10)
    end
  end
  def show
    @exercise = Exercise.includes(workouts: :user).find(params[:id])
  end
end
