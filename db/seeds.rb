require 'faker'
require 'net/http'
require 'json'
require 'csv'
require 'uri'

# Clear Existing Data
puts "Clearing Existing Data"
MealFood.destroy_all
WorkoutExercise.destroy_all
MealLog.destroy_all
Workout.destroy_all
ProgressEntry.destroy_all
Food.destroy_all
FoodCategory.destroy_all
Exercise.destroy_all
User.destroy_all

puts "Creating Food Categories"
food_categories = [
  { name: "Fruits", description: "Natural sweet foods that grow on plants or trees" },
  { name: "Vegetables", description: "Plant foods generally consumed as part of a savory meal" },
  { name: "Grains", description: "Edible seeds of specific grasses" },
  { name: "Protein", description: "Foods that are high in protein content" },
  { name: "Dairy", description: "Foods produced from or containing milk" },
  { name: "Oils & Fats", description: "Fats from various animal and plant sources" },
  { name: "Beverages", description: "Liquids for consumption" },
  { name: "Sweets & Desserts", description: "Sweet foods often consumed at the end of a meal" }
]

created_categories = {}
food_categories.each do |category|
  cat = FoodCategory.create!(category)
  created_categories[cat.name.downcase] = cat
end

puts "Creating Users with Faker"
20.times do
  User.create!(
    username: Faker::Internet.unique.username,
    email: Faker::Internet.unique.email,
    age: Faker::Number.between(from: 16, to: 75),
    height_cm: Faker::Number.between(from: 150, to: 200),
    weight_kg: Faker::Number.between(from: 45, to: 120),
    fitness_level: ["beginner", "intermediate", "advanced"].sample,
    goal: Faker::Lorem.paragraph(sentence_count: 2)
  )
end

# Fetch Exercise Data
puts "Fetching Exercise Data from ExerciseDB API"
api_key = "666652fbd9msh6ee4cb8b2db61ffp1d224fjsn8749db0d564c"

# Make API call
uri = URI("https://exercisedb.p.rapidapi.com/exercises")
request = Net::HTTP::Get.new(uri)
request["X-RapidAPI-Key"] = api_key
request["X-RapidAPI-Host"] = "exercisedb.p.rapidapi.com"

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

begin
  response = http.request(request)

  if response.code == "200"
    exercises_data = JSON.parse(response.body)
    exercises_data = exercises_data.first(50) # Limit to 50 exercises

    puts "Successfully fetched #{exercises_data.length} exercises from API."

    # Create exercises from API data
    exercises_data.each do |exercise_data|
      Exercise.create!(
        name: exercise_data["name"],
        exercise_type: exercise_data["type"] || "Strength",
        target_muscle: exercise_data["muscle"] || exercise_data["target"] || "Full Body",
        equipment_needed: exercise_data["equipment"],
        difficulty: ["beginner", "intermediate", "advanced"].sample,
        instructions: exercise_data["instructions"] || "Perform the exercise with proper technique.",
        image_url: exercise_data["gifUrl"] || "https://via.placeholder.com/200x200.png?text=Exercise+Image"
      )
    end
  else
    puts "API request failed: #{response.code} - #{response.message}"
    raise "API request failed"
  end
rescue => e
  puts "Error fetching exercise data: #{e.message}"
  puts "Using fallback exercise data..."

  # Fallback exercise data
  exercise_types = ["Strength", "Cardio", "Flexibility", "Balance"]
  muscles = ["Chest", "Back", "Shoulders", "Legs", "Arms", "Core", "Full Body"]
  equipment = ["Barbell", "Dumbbell", "Machine", "Body Weight", "Kettebell", "Cable", "Resistance Band"]
  difficulties = ["Beginner", "Intermediate", "Advanced"]

  50.times do
    Exercise.create!(
      name: "#{Faker::Adjective.positive} #{muscles.sample.capitalize} #{Faker::Lorem.word}",
      exercise_type: exercise_types.sample,
      target_muscle: muscles.sample,
      equipment_needed: equipment.sample,
      difficulty: difficulties.sample,
      instructions: "Perform the exercise with proper technique.",
      image_url: "https://via.placeholder.com/200x200.png?text=Exercise+Image"
    )
  end
end

puts "Importing food data from Foundations Food CSV..."

# Check for CSV File
csv_path = Rails.root.join('food.csv')

if File.exist?(csv_path)
  food_category_cache = {}
  processed_foods = 0

  CSV.foreach(csv_path, headers: true) do |row|
    break if processed_foods >= 100

    begin
      category_id = row['food_category_id'].to_i

      unless food_category_cache[category_id]
        food_category_cache[category_id] = FoodCategory.all.sample
      end

      food = Food.create!(
        name: row['description'],
        calories_per_serving: rand(50..500),
        protein_grams: rand(0.0..30.0).round(1),
        carbs_grams: rand(0.0..50.0).round(1),
        fat_grams: rand(0.0..20.0).round(1),
        serving_size: "100g",
        food_category: food_category_cache[category_id]
      )

      processed_foods += 1
      puts "Processed food: #{food.name}" if processed_foods % 10 == 0
    rescue => e
      puts "Error importing food: #{e.message}"
    end
  end
else
  puts "CSV file not found: #{csv_path}. Creating sample food data..."

  60.times do
    category = FoodCategory.all.sample

    Food.create!(
      name: "#{Faker::Adjective.positive} #{Faker::Food.ingredient}",
      calories_per_serving: Faker::Number.between(from: 50, to: 500),
      protein_grams: Faker::Number.decimal(l_digits: 1, r_digits: 1),
      carbs_grams: Faker::Number.decimal(l_digits: 1, r_digits: 1),
      fat_grams: Faker::Number.decimal(l_digits: 1, r_digits: 1),
      serving_size: ["1 cup", "100g", "1 tbsp", "1 oz", "1 serving"].sample,
      food_category: category
    )
  end
end

puts "Creating workouts and associating exercises..."
User.all.each do |user|
  # Each user gets 2-6 workouts
  (2..6).to_a.sample.times do
    workout = user.workouts.create!(
      name: ["Morning Workout", "Cardio Day", "Strength Training", "Full Body", "Upper Body", "Lower Body"].sample,
      date: Faker::Date.between(from: 30.days.ago, to: Date.today),
      duration_minutes: [30, 45, 60, 90].sample,
      notes: Faker::Lorem.paragraph(sentence_count: 2)
    )

    # Each workout has 3-8 exercises
    exercises = Exercise.all.sample((3..8).to_a.sample)
    exercises.each do |exercise|
      if exercise.exercise_type.downcase == "strength"
        workout.workout_exercises.create!(
          exercise: exercise,
          sets: (3..5).to_a.sample,
          reps: (8..15).to_a.sample,
          weight_kg: (5..50).to_a.sample,
          duration_minutes: nil
        )
      else
        workout.workout_exercises.create!(
          exercise: exercise,
          sets: nil,
          reps: nil,
          weight_kg: nil,
          duration_minutes: (5..30).to_a.sample
        )
      end
    end
  end
end

puts "Creating meal logs and food entries..."
# Create meal logs for users
User.all.each do |user|
  # Each user gets 3-7 meal logs
  (3..7).to_a.sample.times do
    meal_log = user.meal_logs.create!(
      date: Faker::Date.between(from: 14.days.ago, to: Date.today),
      meal_type: ["breakfast", "lunch", "dinner", "snack", "other"].sample,
      notes: Faker::Lorem.sentence
    )

    # Each meal has 1-5 foods
    foods = Food.all.sample((1..5).to_a.sample)

    foods.each do |food|
      meal_log.meal_foods.create!(
        food: food,
        servings: [0.5, 1, 1.5, 2].sample
      )
    end
  end
end

puts "Creating progress entries..."
# Create progress entries for users
User.all.each do |user|
  # Each user gets 3-10 progress entries
  entry_dates = (1..10).to_a.sample(rand(3..10)).map { |n| n.days.ago.to_date }.sort

  entry_dates.each do |date|
    # Slight weight variations for realistic tracking
    weight_variation = rand(-2.0..2.0).round(1)

    user.progress_entries.create!(
      date: date,
      weight_kg: user.weight_kg + weight_variation,
      notes: ["Feeling good", "Tired today", "Great energy", "Need more sleep", "Stressed", "Motivated"].sample
    )
  end
end

# Count rows in each table for verification
puts "\nSeeding complete!"
puts "Generated the following records:"
puts "Users: #{User.count}"
puts "Exercises: #{Exercise.count}"
puts "Food Categories: #{FoodCategory.count}"
puts "Foods: #{Food.count}"
puts "Workouts: #{Workout.count}"
puts "Workout Exercises: #{WorkoutExercise.count}"
puts "Meal Logs: #{MealLog.count}"
puts "Meal Foods: #{MealFood.count}"
puts "Progress Entries: #{ProgressEntry.count}"
puts "Total rows: #{User.count + Exercise.count + FoodCategory.count + Food.count + Workout.count + WorkoutExercise.count + MealLog.count + MealFood.count + ProgressEntry.count}"