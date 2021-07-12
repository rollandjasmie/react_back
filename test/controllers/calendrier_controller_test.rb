require 'test_helper'

class CalendrierControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get calendrier_index_url
    assert_response :success
  end

  test "should get update" do
    get calendrier_update_url
    assert_response :success
  end

end
