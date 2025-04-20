class FoodCategoriesController < ApplicationController
  def index
    @food_categories = FoodCategory.all
  end

  def show
    @food_category = FoodCategory.find(params[:id])
    @foods = @food_category.foods
  end
end
