require 'test_helper'

class ConversationClientsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get conversation_clients_index_url
    assert_response :success
  end

  test "should get create" do
    get conversation_clients_create_url
    assert_response :success
  end

end
