class GymsController < ApplicationController
  def index
    @gyms = Gym.page(params[:page]).per(10)
  end

  def show
    @gym = Gym.find(params[:id])
    @workouts = @gym.workouts.includes(:user).limit(10)
  end
end
