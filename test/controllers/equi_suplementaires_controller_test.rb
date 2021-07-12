require 'test_helper'

class EquiSuplementairesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equi_suplementaire = equi_suplementaires(:one)
  end

  test "should get index" do
    get equi_suplementaires_url, as: :json
    assert_response :success
  end

  test "should create equi_suplementaire" do
    assert_difference('EquiSuplementaire.count') do
      post equi_suplementaires_url, params: { equi_suplementaire: { logement_id: @equi_suplementaire.logement_id, title: @equi_suplementaire.title } }, as: :json
    end

    assert_response 201
  end

  test "should show equi_suplementaire" do
    get equi_suplementaire_url(@equi_suplementaire), as: :json
    assert_response :success
  end

  test "should update equi_suplementaire" do
    patch equi_suplementaire_url(@equi_suplementaire), params: { equi_suplementaire: { logement_id: @equi_suplementaire.logement_id, title: @equi_suplementaire.title } }, as: :json
    assert_response 200
  end

  test "should destroy equi_suplementaire" do
    assert_difference('EquiSuplementaire.count', -1) do
      delete equi_suplementaire_url(@equi_suplementaire), as: :json
    end

    assert_response 204
  end
end
