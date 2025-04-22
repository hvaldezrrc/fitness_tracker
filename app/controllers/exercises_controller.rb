class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all

    if params[:search].present?
      @exercises = @exercises.where("name LIKE ? OR target_muscle LIKE ? OR exercise_type LIKE ?",
                                   "%#{params[:search]}%",
                                   "%#{params[:search]}%",
                                   "%#{params[:search]}%")
    end

    if params[:equipment].present? && params[:equipment] != ""
      @exercises = @exercises.where(equipment_needed: params[:equipment])
    end

    @equipment_list = Exercise.distinct.pluck(:equipment_needed).sort
    @exercises = @exercises.page(params[:page]).per(10)
  end
  def show
    @exercise = Exercise.includes(workouts: :user).find(params[:id])
  end
end
