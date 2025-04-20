require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get workout_url(workouts(:one))
    assert_response :success
  end
end
