class FoodCategory < ApplicationRecord
  has_many :foods

  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 1000 }
end
