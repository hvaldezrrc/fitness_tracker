class MealLog < ApplicationRecord
  belongs_to :user
  has_many :meal_foods, dependent: :destroy
  has_many :foods, through: :meal_foods

  validates :date, presence: true
  validates :meal_type, inclusion: { in: %w(breakfast lunch dinner snack other) }
end
