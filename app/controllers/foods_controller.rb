class FoodsController < ApplicationController
  def index
    @foods = Food.page(params[:page]).per(10)
  end

  def show
    @foods = Food.includes(:food_category, meal_logs: [ :user, :meal_foods ]).find(params[:id])
  end
end
