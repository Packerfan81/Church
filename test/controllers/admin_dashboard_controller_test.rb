require "test_helper"

class AdminDashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_dashboard_show_url
    assert_response :success
  end
end
