class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :exercise_type
      t.string :target_muscle
      t.string :equipment_needed
      t.string :difficulty
      t.text :instructions
      t.string :image_url

      t.timestamps
    end
  end
end
