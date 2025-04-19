class ProgressEntry < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :weight_kg, numericality: { greater_than: 0 }, presence: true
end
