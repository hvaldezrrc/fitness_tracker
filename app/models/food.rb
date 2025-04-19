class Food < ApplicationRecord
  belongs_to :food_category
  has_many :meal_foods
  has_many :meal_logs, through: :meal_foods

  validates :name, presence: true
  validates :calories_per_serving, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :protein_grams, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :carbs_grams, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :fat_grams, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
