require 'test_helper'

class TaxesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get taxes_index_url
    assert_response :success
  end

  test "should get update" do
    get taxes_update_url
    assert_response :success
  end

end
