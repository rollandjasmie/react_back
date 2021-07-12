require 'test_helper'

class DestinationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get destination_index_url
    assert_response :success
  end

end
