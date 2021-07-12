require 'test_helper'

class AdminRunControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_run_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_run_show_url
    assert_response :success
  end

  test "should get upadte" do
    get admin_run_upadte_url
    assert_response :success
  end

end
