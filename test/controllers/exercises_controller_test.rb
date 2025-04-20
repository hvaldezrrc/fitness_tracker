require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get exercises_url
    assert_response :success
  end
end
