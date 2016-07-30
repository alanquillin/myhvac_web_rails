require 'test_helper'

class RoomSensorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get room_sensors_index_url
    assert_response :success
  end

  test "should get show" do
    get room_sensors_show_url
    assert_response :success
  end

  test "should get new" do
    get room_sensors_new_url
    assert_response :success
  end

  test "should get create" do
    get room_sensors_create_url
    assert_response :success
  end

  test "should get edit" do
    get room_sensors_edit_url
    assert_response :success
  end

  test "should get update" do
    get room_sensors_update_url
    assert_response :success
  end

  test "should get destroy" do
    get room_sensors_destroy_url
    assert_response :success
  end

end
