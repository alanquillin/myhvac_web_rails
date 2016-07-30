require 'test_helper'

class SystemControllerTest < ActionDispatch::IntegrationTest
  test "should get ping" do
    get system_ping_url
    assert_response :success
  end

end
