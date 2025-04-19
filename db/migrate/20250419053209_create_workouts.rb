class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.date :date
      t.integer :duration_minutes
      t.text :notes

      t.timestamps
    end
  end
end
