require 'test_helper'

class SensorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sensors_index_url
    assert_response :success
  end

  test "should get show" do
    get sensors_show_url
    assert_response :success
  end

  test "should get new" do
    get sensors_new_url
    assert_response :success
  end

  test "should get create" do
    get sensors_create_url
    assert_response :success
  end

  test "should get edit" do
    get sensors_edit_url
    assert_response :success
  end

  test "should get update" do
    get sensors_update_url
    assert_response :success
  end

  test "should get destroy" do
    get sensors_destroy_url
    assert_response :success
  end

end
