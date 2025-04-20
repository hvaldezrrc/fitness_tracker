class CreateGyms < ActiveRecord::Migration[8.0]
  def change
    create_table :gyms do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :description
      t.string :website
      t.string :phone

      t.timestamps
    end
  end
end
