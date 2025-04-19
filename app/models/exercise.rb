class Exercise < ApplicationRecord
  has_many :workout_exercises
  has_many :workouts, through: :workout_exercises

  validates :name, presence: true
  validates :exercise_type, presence: true
  validates :target_muscle, presence: true
  validates :difficulty, inclusion: { in: %w[beginner intermediate advanced] }, allow_nil: true
end
