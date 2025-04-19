class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.integer :age
      t.float :height_cm
      t.float :weight_kg
      t.string :fitness_level
      t.text :goal

      t.timestamps
    end
  end
end
