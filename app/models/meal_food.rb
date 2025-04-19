class MealFood < ApplicationRecord
  belongs_to :meal_log
  belongs_to :food

  validates :servings, numericality: { greater_than: 0 }, presence: true
end
