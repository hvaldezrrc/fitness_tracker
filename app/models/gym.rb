class Gym < ApplicationRecord
  has_many :workouts

  validates :name, presence: true
  validates :address, presence: true
end
