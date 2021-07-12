require 'test_helper'

class ProritaireControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get proritaire_index_url
    assert_response :success
  end

end
