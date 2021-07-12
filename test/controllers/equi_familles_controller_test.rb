require 'test_helper'

class EquiFamillesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equi_famille = equi_familles(:one)
  end

  test "should get index" do
    get equi_familles_url, as: :json
    assert_response :success
  end

  test "should create equi_famille" do
    assert_difference('EquiFamille.count') do
      post equi_familles_url, params: { equi_famille: { logement_id: @equi_famille.logement_id, title: @equi_famille.title } }, as: :json
    end

    assert_response 201
  end

  test "should show equi_famille" do
    get equi_famille_url(@equi_famille), as: :json
    assert_response :success
  end

  test "should update equi_famille" do
    patch equi_famille_url(@equi_famille), params: { equi_famille: { logement_id: @equi_famille.logement_id, title: @equi_famille.title } }, as: :json
    assert_response 200
  end

  test "should destroy equi_famille" do
    assert_difference('EquiFamille.count', -1) do
      delete equi_famille_url(@equi_famille), as: :json
    end

    assert_response 204
  end
end
