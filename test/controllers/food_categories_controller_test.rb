require "test_helper"

class FoodCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get food_categories_url
    assert_response :success
  end

  test "should get show" do
    get food_categories_url(food_categories(:one))
    assert_response :success
  end
end
