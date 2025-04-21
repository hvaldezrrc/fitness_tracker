class FoodsController < ApplicationController
  def index
    if params[:search].present?
      @foods = Food.where("name LIKE ?", "%#{params[:search]}%")
                  .page(params[:page]).per(10)
    else
      @foods = Food.page(params[:page]).per(10)
    end
  end

  def show
    begin
      @food = Food.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Food not found"
      redirect_to foods_path
      nil
    end
  end
end
