require 'test_helper'

class Admin::RechercheControllerTest < ActionDispatch::IntegrationTest
  test "should get users" do
    get admin_recherche_users_url
    assert_response :success
  end

  test "should get logement" do
    get admin_recherche_logement_url
    assert_response :success
  end

  test "should get reservation" do
    get admin_recherche_reservation_url
    assert_response :success
  end

end
