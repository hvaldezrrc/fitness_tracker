class CreateFoodCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :food_categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
