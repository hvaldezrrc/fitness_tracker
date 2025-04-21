class GymsController < ApplicationController
  def index
    @gyms = Gym.page(params[:page]).per(10)
  end

  def show
    begin
      @gym = Gym.find(params[:id])
      @workouts = @gym.workouts.includes(:user).limit(10)
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Gym not found"
      redirect_to gyms_path
      nil
    end
  end
end
