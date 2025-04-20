class FoodsController < ApplicationController
  def index
    @foods = Food.page(params[:page]).per(30)
  end

  def show
    begin
      @food = Food.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Food not found"
      redirect_to foods_path
      return
    end
  end
end
