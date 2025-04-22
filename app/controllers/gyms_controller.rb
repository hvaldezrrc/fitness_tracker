class GymsController < ApplicationController
  def index
    gym_names = Gym.distinct.pluck(:name)
    @gyms = gym_names.map { |name| Gym.where(name: name).first }
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
