require 'test_helper'

class CogestionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cogestion_index_url
    assert_response :success
  end

  test "should get delete" do
    get cogestion_delete_url
    assert_response :success
  end

end
