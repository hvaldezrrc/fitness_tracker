class FoodCategoriesController < ApplicationController
  def index
    @food_categories = FoodCategory.page(params[:page]).per(10)
  end

  def show
    @food_category = FoodCategory.find(params[:id])
    @foods = @food_category.foods.page(params[:page]).per(10)
  end
end
