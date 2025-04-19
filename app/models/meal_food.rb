class MealFood < ApplicationRecord
  belongs_to :meal_log
  belongs_to :food
end
