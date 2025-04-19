class CreateProgressEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :progress_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.float :weight_kg
      t.text :notes

      t.timestamps
    end
  end
end
