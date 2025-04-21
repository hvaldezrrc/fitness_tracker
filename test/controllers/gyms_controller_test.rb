require "test_helper"

class GymsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gym = Gym.create!(
      name: "Test Gym",
      address: "123 Test St, Winnipeg, MB",
      latitude: 49.8951,
      longitude: -97.1384,
      description: "A test gym",
      website: "http://example.com",
      phone: "(204) 555-1234"
    )
  end

  test "should get index" do
    get gyms_url
    assert_response :success
  end

  test "should get show" do
    get gym_url(@gym)
    assert_response :success
  end
end
