require 'test_helper'

class Admin::LogementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_logements_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_logements_show_url
    assert_response :success
  end

  test "should get delete" do
    get admin_logements_delete_url
    assert_response :success
  end

end
