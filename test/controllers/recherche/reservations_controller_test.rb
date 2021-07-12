require 'test_helper'

class Recherche::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recherche_reservations_index_url
    assert_response :success
  end

  test "should get show" do
    get recherche_reservations_show_url
    assert_response :success
  end

end
