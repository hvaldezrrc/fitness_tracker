class CreateMealLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.string :meal_type
      t.text :notes

      t.timestamps
    end
  end
end
