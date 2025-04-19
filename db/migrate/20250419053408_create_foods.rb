class CreateFoods < ActiveRecord::Migration[8.0]
  def change
    create_table :foods do |t|
      t.string :name
      t.integer :calories_per_serving
      t.float :protein_grams
      t.float :carbs_grams
      t.float :fat_grams
      t.string :serving_size
      t.references :food_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
