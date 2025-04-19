class User < ApplicationRecord
  has_many :workouts, dependent: :destroy
  has_many :meal_logs, dependent: :destroy
  has_many :progress_entries, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 120 }, allow_nil: true
  validates :height_cm, numericality: { greater_than: 0 }, allow_nil: true
  validates :weight_kg, numericality: { greater_than: 0 }, allow_nil: true
end
