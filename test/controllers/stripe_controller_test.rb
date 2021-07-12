require 'test_helper'

class StripeControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stripe_create_url
    assert_response :success
  end

end
