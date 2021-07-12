require 'test_helper'

class ReglesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get regles_index_url
    assert_response :success
  end

  test "should get update" do
    get regles_update_url
    assert_response :success
  end

end
