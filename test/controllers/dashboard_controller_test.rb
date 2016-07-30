require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should show index" do
    show dashboard_index_url
    assert_response :success
  end

end
