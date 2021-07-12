require 'test_helper'

class EquiSecuritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equi_securite = equi_securites(:one)
  end

  test "should get index" do
    get equi_securites_url, as: :json
    assert_response :success
  end

  test "should create equi_securite" do
    assert_difference('EquiSecurite.count') do
      post equi_securites_url, params: { equi_securite: { logement_id: @equi_securite.logement_id, title: @equi_securite.title } }, as: :json
    end

    assert_response 201
  end

  test "should show equi_securite" do
    get equi_securite_url(@equi_securite), as: :json
    assert_response :success
  end

  test "should update equi_securite" do
    patch equi_securite_url(@equi_securite), params: { equi_securite: { logement_id: @equi_securite.logement_id, title: @equi_securite.title } }, as: :json
    assert_response 200
  end

  test "should destroy equi_securite" do
    assert_difference('EquiSecurite.count', -1) do
      delete equi_securite_url(@equi_securite), as: :json
    end

    assert_response 204
  end
end
