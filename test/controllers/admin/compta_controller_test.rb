require 'test_helper'

class Admin::ComptaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_compta_index_url
    assert_response :success
  end

end
