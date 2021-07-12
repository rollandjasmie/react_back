require 'test_helper'

class RessouceVoyageursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ressouce_voyageur = ressouce_voyageurs(:one)
  end

  test "should get index" do
    get ressouce_voyageurs_url, as: :json
    assert_response :success
  end

  test "should create ressouce_voyageur" do
    assert_difference('RessouceVoyageur.count') do
      post ressouce_voyageurs_url, params: { ressouce_voyageur: { logements_id: @ressouce_voyageur.logements_id, title: @ressouce_voyageur.title } }, as: :json
    end

    assert_response 201
  end

  test "should show ressouce_voyageur" do
    get ressouce_voyageur_url(@ressouce_voyageur), as: :json
    assert_response :success
  end

  test "should update ressouce_voyageur" do
    patch ressouce_voyageur_url(@ressouce_voyageur), params: { ressouce_voyageur: { logements_id: @ressouce_voyageur.logements_id, title: @ressouce_voyageur.title } }, as: :json
    assert_response 200
  end

  test "should destroy ressouce_voyageur" do
    assert_difference('RessouceVoyageur.count', -1) do
      delete ressouce_voyageur_url(@ressouce_voyageur), as: :json
    end

    assert_response 204
  end
end
