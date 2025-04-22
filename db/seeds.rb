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
    fitness_level: [ "beginner", "intermediate", "advanced" ].sample,
    goal: Faker::Lorem.paragraph(sentence_count: 2)
  )
end

# Fetch Exercise Data
puts "Fetching Exercise Data from ExerciseDB API"
api_key = "666652fbd9msh6ee4cb8b2db61ffp1d224fjsn8749db0d564c"

puts "Attempting to fetch all exercises..."

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
    puts "Successfully fetched #{exercises_data.length} exercises from API."

    if exercises_data.length <= 10
      puts "API returned a limited set. Trying to fetch exercises by body part..."

      body_parts = [ "back", "cardio", "chest", "lower arms", "lower legs",
                   "neck", "shoulders", "upper arms", "upper legs", "waist" ]

      all_exercises = []

      body_parts.each do |body_part|
        body_part_uri = URI("https://exercisedb.p.rapidapi.com/exercises/bodyPart/#{URI.encode_www_form_component(body_part)}")
        body_part_request = Net::HTTP::Get.new(body_part_uri)
        body_part_request["X-RapidAPI-Key"] = api_key
        body_part_request["X-RapidAPI-Host"] = "exercisedb.p.rapidapi.com"

        body_part_response = http.request(body_part_request)

        if body_part_response.code == "200"
          part_exercises = JSON.parse(body_part_response.body)
          puts "Fetched #{part_exercises.length} exercises for body part: #{body_part}"
          all_exercises.concat(part_exercises)
        end

        # Sleep briefly to avoid rate limiting
        sleep(1)
      end

      # Remove duplicates based on name
      all_exercises.uniq! { |ex| ex["name"] }
      puts "Total unique exercises after fetching by body part: #{all_exercises.length}"

      exercises_data = all_exercises
    end

    # Create exercises from API data
    created_count = 0
    exercises_data.each do |exercise_data|
      begin
        Exercise.create!(
          name: exercise_data["name"],
          exercise_type: exercise_data["type"] || "strength",
          target_muscle: exercise_data["muscle"] || exercise_data["target"] || "full body",
          equipment_needed: exercise_data["equipment"],
          difficulty: [ "beginner", "intermediate", "advanced" ].sample,
          instructions: exercise_data["instructions"] || "Perform the exercise with proper technique.",
          image_url: exercise_data["gifUrl"] || "https://via.placeholder.com/200x200.png?text=Exercise+Image"
        )
        created_count += 1
        puts "Created exercise #{created_count}: #{exercise_data["name"]}" if created_count % 10 == 0
      rescue => e
        puts "Error creating exercise '#{exercise_data["name"]}': #{e.message}"
      end
    end

    puts "Successfully created #{created_count} exercises from API data."
  else
    puts "API request failed: #{response.code} - #{response.message}"
    raise "API request failed"
  end
rescue => e
  # Fallback exercise data generation in case the API fails
  puts "Error fetching exercise data: #{e.message}"
  puts "Using fallback exercise data..."

end

puts "Importing food data from Foundations Food CSV..."

# Check for CSV File
csv_path = Rails.root.join('food.csv')

if File.exist?(csv_path)
  processed_foods = 0
  categories = FoodCategory.all.to_a

  used_names = Set.new

  skip_counter = 0
  skip_increment = 500

  CSV.foreach(csv_path, headers: true) do |row|
    skip_counter += 1
    next if skip_counter % skip_increment != 0

    break if processed_foods >= 100

    begin
      name = row['description'].to_s.strip

      next if name.empty? || used_names.include?(name.downcase) || name.upcase.include?("HUMMUS")

      used_names.add(name.downcase)

      category = categories[processed_foods % categories.length]

      food = Food.create!(
        name: name,
        calories_per_serving: rand(50..500),
        protein_grams: rand(0.0..30.0).round(1),
        carbs_grams: rand(0.0..50.0).round(1),
        fat_grams: rand(0.0..20.0).round(1),
        serving_size: "100g",
        food_category: category
      )

      processed_foods += 1
      puts "Processed food: #{food.name} (Category: #{category.name})" if processed_foods % 10 == 0
    rescue => e
      puts "Error importing food: #{e.message}"
    end
  end

  if processed_foods < 100
    remaining = 100 - processed_foods
    puts "Only found #{processed_foods} unique foods in CSV. Adding #{remaining} predefined foods..."

    category_foods = {
      "Fruits" => [ "Apple", "Banana", "Orange", "Strawberry", "Blueberry", "Raspberry", "Watermelon", "Pineapple", "Mango", "Peach" ],
      "Vegetables" => [ "Carrot", "Broccoli", "Spinach", "Kale", "Cucumber", "Tomato", "Bell Pepper", "Onion", "Garlic", "Potato" ],
      "Grains" => [ "Brown Rice", "White Rice", "Quinoa", "Oats", "Barley", "Whole Wheat Bread", "Pasta", "Couscous", "Bulgur", "Rye Bread" ],
      "Protein" => [ "Chicken Breast", "Ground Beef", "Salmon", "Tuna", "Eggs", "Tofu", "Tempeh", "Black Beans", "Chickpeas", "Lentils" ],
      "Dairy" => [ "Milk", "Yogurt", "Cheddar Cheese", "Mozzarella", "Cottage Cheese", "Greek Yogurt", "Butter", "Ice Cream", "Cream Cheese", "Sour Cream" ],
      "Oils & Fats" => [ "Olive Oil", "Coconut Oil", "Avocado Oil", "Vegetable Oil", "Butter", "Ghee", "Lard", "Tallow", "Walnut Oil", "Sesame Oil" ],
      "Beverages" => [ "Coffee", "Tea", "Orange Juice", "Apple Juice", "Smoothie", "Water", "Sparkling Water", "Kombucha", "Lemonade", "Soda" ],
      "Sweets & Desserts" => [ "Chocolate Cake", "Ice Cream", "Cookie", "Brownie", "Pie", "Cupcake", "Donut", "Chocolate Bar", "Candy", "Cheesecake" ]
    }

    current_category_index = processed_foods % categories.length
    (0...remaining).each do |i|
      category = categories[current_category_index]
      current_category_index = (current_category_index + 1) % categories.length

      foods_list = category_foods[category.name] || []
      food_name = foods_list[i % foods_list.length]

      food_name = "#{Faker::Adjective.positive} #{food_name}" if used_names.include?(food_name.downcase)
      used_names.add(food_name.downcase)

      Food.create!(
        name: food_name,
        calories_per_serving: rand(50..500),
        protein_grams: rand(0.0..30.0).round(1),
        carbs_grams: rand(0.0..50.0).round(1),
        fat_grams: rand(0.0..20.0).round(1),
        serving_size: [ "1 cup", "100g", "1 tbsp", "1 oz", "1 serving" ].sample,
        food_category: category
      )

      processed_foods += 1
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
      serving_size: [ "1 cup", "100g", "1 tbsp", "1 oz", "1 serving" ].sample,
      food_category: category
    )
  end
end

puts "Creating workouts and associating exercises..."
User.all.each do |user|
  (2..6).to_a.sample.times do
    workout = user.workouts.create!(
      name: [ "Morning Workout", "Cardio Day", "Strength Training", "Full Body", "Upper Body", "Lower Body" ].sample,
      date: Faker::Date.between(from: 30.days.ago, to: Date.today),
      duration_minutes: [ 30, 45, 60, 90 ].sample,
      notes: Faker::Lorem.paragraph(sentence_count: 2)
    )

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
User.all.each do |user|
  (3..7).to_a.sample.times do
    meal_log = user.meal_logs.create!(
      date: Faker::Date.between(from: 14.days.ago, to: Date.today),
      meal_type: [ "breakfast", "lunch", "dinner", "snack", "other" ].sample,
      notes: Faker::Lorem.sentence
    )

    foods = Food.all.sample((1..5).to_a.sample)

    foods.each do |food|
      meal_log.meal_foods.create!(
        food: food,
        servings: [ 0.5, 1, 1.5, 2 ].sample
      )
    end
  end
end

puts "Creating progress entries..."
User.all.each do |user|
  entry_dates = (1..10).to_a.sample(rand(3..10)).map { |n| n.days.ago.to_date }.sort

  entry_dates.each do |date|
    weight_variation = rand(-2.0..2.0).round(1)

    user.progress_entries.create!(
      date: date,
      weight_kg: user.weight_kg + weight_variation,
      notes: [ "Feeling good", "Tired today", "Great energy", "Need more sleep", "Stressed", "Motivated" ].sample
    )
  end
end

# Create gyms in Winnipeg
winnipeg_gyms = [
  {
    name: "Altea Active",
    address: "100 S Town Rd, Winnipeg, MB R3Y 0V8",
    latitude: 49.8070,
    longitude: -97.1953,
    description: "Premium fitness club with extensive amenities including pools, courts, and diverse fitness classes.",
    website: "https://www.alteaactive.com",
    phone: "(204) 808-7082"
  },
  {
    name: "GoodLife Refinery",
    address: "300 Newmarket Blvd, Winnipeg, MB R3T 6G7",
    latitude: 49.8071,
    longitude: -97.1594,
    description: "Full-service fitness center with cardio and strength equipment, plus group classes.",
    website: "https://www.goodlifefitness.com",
    phone: "(204) 786-3942"
  },
  {
    name: "GoodLife Grant",
    address: "1120 Grant Ave, Winnipeg, MB R3M 2A6",
    latitude: 49.8566,
    longitude: -97.1767,
    description: "Popular gym offering a range of cardio machines, free weights, and group fitness classes.",
    website: "https://www.goodlifefitness.com",
    phone: "(204) 488-0816"
  },
  {
    name: "Fit4Less",
    address: "1225 St Mary's Rd, Winnipeg, MB R2M 5E5",
    latitude: 49.8235,
    longitude: -97.1125,
    description: "Budget-friendly gym with quality equipment at affordable rates.",
    website: "https://www.fit4less.ca",
    phone: "(204) 504-5333"
  },
  {
    name: "Crunch Fitness",
    address: "143 Nature Park Way, Winnipeg, MB R3P 0Y6",
    latitude: 49.8319,
    longitude: -97.1917,
    description: "Fitness center known for its 'No Judgments' philosophy and diverse equipment offerings.",
    website: "https://www.crunchfitness.com",
    phone: "(204) 615-1010"
  }
]

puts "Creating Winnipeg gyms..."
winnipeg_gyms.each do |gym_data|
  unless Gym.exists?(name: gym_data[:name])
    Gym.create!(gym_data)
  end
end

if Workout.any? && Gym.any?
  puts "Associating workouts with gyms..."
  Workout.all.sample(Workout.count / 2).each do |workout|
    workout.update(gym: Gym.all.sample)
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
puts "Gyms: #{Gym.count}"
