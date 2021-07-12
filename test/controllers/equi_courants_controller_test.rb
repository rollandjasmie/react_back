require 'test_helper'

class EquiCourantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equi_courant = equi_courants(:one)
  end

  test "should get index" do
    get equi_courants_url, as: :json
    assert_response :success
  end

  test "should create equi_courant" do
    assert_difference('EquiCourant.count') do
      post equi_courants_url, params: { equi_courant: { logement_id: @equi_courant.logement_id, title: @equi_courant.title } }, as: :json
    end

    assert_response 201
  end

  test "should show equi_courant" do
    get equi_courant_url(@equi_courant), as: :json
    assert_response :success
  end

  test "should update equi_courant" do
    patch equi_courant_url(@equi_courant), params: { equi_courant: { logement_id: @equi_courant.logement_id, title: @equi_courant.title } }, as: :json
    assert_response 200
  end

  test "should destroy equi_courant" do
    assert_difference('EquiCourant.count', -1) do
      delete equi_courant_url(@equi_courant), as: :json
    end

    assert_response 204
  end
end
