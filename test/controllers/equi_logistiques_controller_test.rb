require 'test_helper'

class EquiLogistiquesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equi_logistique = equi_logistiques(:one)
  end

  test "should get index" do
    get equi_logistiques_url, as: :json
    assert_response :success
  end

  test "should create equi_logistique" do
    assert_difference('EquiLogistique.count') do
      post equi_logistiques_url, params: { equi_logistique: { logement_id: @equi_logistique.logement_id, title: @equi_logistique.title } }, as: :json
    end

    assert_response 201
  end

  test "should show equi_logistique" do
    get equi_logistique_url(@equi_logistique), as: :json
    assert_response :success
  end

  test "should update equi_logistique" do
    patch equi_logistique_url(@equi_logistique), params: { equi_logistique: { logement_id: @equi_logistique.logement_id, title: @equi_logistique.title } }, as: :json
    assert_response 200
  end

  test "should destroy equi_logistique" do
    assert_difference('EquiLogistique.count', -1) do
      delete equi_logistique_url(@equi_logistique), as: :json
    end

    assert_response 204
  end
end
