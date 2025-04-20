class FoodsController < ApplicationController
  def index
    @foods = Food.all
  end

  def show
    @foods = Food.find(params[:id])
  end
end
