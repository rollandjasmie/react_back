require 'test_helper'

class MessageClientsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get message_clients_index_url
    assert_response :success
  end

  test "should get create" do
    get message_clients_create_url
    assert_response :success
  end

end
