# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_19_053556) do
  create_table "exercises", force: :cascade do |t|
    t.string "name"
    t.string "exercise_type"
    t.string "target_muscle"
    t.string "equipment_needed"
    t.string "difficulty"
    t.text "instructions"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.integer "calories_per_serving"
    t.float "protein_grams"
    t.float "carbs_grams"
    t.float "fat_grams"
    t.string "serving_size"
    t.integer "food_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_category_id"], name: "index_foods_on_food_category_id"
  end

  create_table "meal_foods", force: :cascade do |t|
    t.integer "meal_log_id", null: false
    t.integer "food_id", null: false
    t.float "servings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_meal_foods_on_food_id"
    t.index ["meal_log_id"], name: "index_meal_foods_on_meal_log_id"
  end

  create_table "meal_logs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date"
    t.string "meal_type"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meal_logs_on_user_id"
  end

  create_table "progress_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date"
    t.float "weight_kg"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_progress_entries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.integer "age"
    t.float "height_cm"
    t.float "weight_kg"
    t.string "fitness_level"
    t.text "goal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workout_exercises", force: :cascade do |t|
    t.integer "workout_id", null: false
    t.integer "exercise_id", null: false
    t.integer "sets"
    t.integer "reps"
    t.float "weight_kg"
    t.integer "duration_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_workout_exercises_on_exercise_id"
    t.index ["workout_id"], name: "index_workout_exercises_on_workout_id"
  end

  create_table "workouts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.date "date"
    t.integer "duration_minutes"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workouts_on_user_id"
  end

  add_foreign_key "foods", "food_categories"
  add_foreign_key "meal_foods", "foods"
  add_foreign_key "meal_foods", "meal_logs"
  add_foreign_key "meal_logs", "users"
  add_foreign_key "progress_entries", "users"
  add_foreign_key "workout_exercises", "exercises"
  add_foreign_key "workout_exercises", "workouts"
  add_foreign_key "workouts", "users"
end
