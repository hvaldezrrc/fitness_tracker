class FoodsController < ApplicationController
  def index
    @foods = Food.includes(:food_category)
    @food_categories = FoodCategory.all

    if params[:search].present?
      @foods = @foods.where("name LIKE ?", "%#{params[:search]}%")
    end

    if params[:category_id].present? && params[:category_id] != ""
      @foods = @foods.where(food_category_id: params[:category_id])
    end

    @foods = @foods.page(params[:page]).per(10)
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
