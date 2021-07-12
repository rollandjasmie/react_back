require 'test_helper'

class AccesVoyageursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @acces_voyageur = acces_voyageurs(:one)
  end

  test "should get index" do
    get acces_voyageurs_url, as: :json
    assert_response :success
  end

  test "should create acces_voyageur" do
    assert_difference('AccesVoyageur.count') do
      post acces_voyageurs_url, params: { acces_voyageur: { acces: @acces_voyageur.acces, aide1: @acces_voyageur.aide1, aide2: @acces_voyageur.aide2, autre: @acces_voyageur.autre, logements_id: @acces_voyageur.logements_id } }, as: :json
    end

    assert_response 201
  end

  test "should show acces_voyageur" do
    get acces_voyageur_url(@acces_voyageur), as: :json
    assert_response :success
  end

  test "should update acces_voyageur" do
    patch acces_voyageur_url(@acces_voyageur), params: { acces_voyageur: { acces: @acces_voyageur.acces, aide1: @acces_voyageur.aide1, aide2: @acces_voyageur.aide2, autre: @acces_voyageur.autre, logements_id: @acces_voyageur.logements_id } }, as: :json
    assert_response 200
  end

  test "should destroy acces_voyageur" do
    assert_difference('AccesVoyageur.count', -1) do
      delete acces_voyageur_url(@acces_voyageur), as: :json
    end

    assert_response 204
  end
end
