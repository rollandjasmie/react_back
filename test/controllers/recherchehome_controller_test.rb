require 'test_helper'

class RecherchehomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recherchehome_index_url
    assert_response :success
  end

end
