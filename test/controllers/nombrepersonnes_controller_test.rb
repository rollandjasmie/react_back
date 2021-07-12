require 'test_helper'

class NombrepersonnesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nombrepersonnes_index_url
    assert_response :success
  end

  test "should get create" do
    get nombrepersonnes_create_url
    assert_response :success
  end

  test "should get update" do
    get nombrepersonnes_update_url
    assert_response :success
  end

end
