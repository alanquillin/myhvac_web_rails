require 'test_helper'

class MeasurementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sensor_measurements_index_url
    assert_response :success
  end

end
