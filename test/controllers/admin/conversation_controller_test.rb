require 'test_helper'

class Admin::ConversationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_conversation_index_url
    assert_response :success
  end

  test "should get create" do
    get admin_conversation_create_url
    assert_response :success
  end

end
