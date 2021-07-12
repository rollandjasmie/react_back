require 'test_helper'

class FraisSuplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @frais_suple = frais_suples(:one)
  end

  test "should get index" do
    get frais_suples_url, as: :json
    assert_response :success
  end

  test "should create frais_suple" do
    assert_difference('FraisSuple.count') do
      post frais_suples_url, params: { frais_suple: { facturation: @frais_suple.facturation, montant: @frais_suple.montant, references: @frais_suple.references, type: @frais_suple.type } }, as: :json
    end

    assert_response 201
  end

  test "should show frais_suple" do
    get frais_suple_url(@frais_suple), as: :json
    assert_response :success
  end

  test "should update frais_suple" do
    patch frais_suple_url(@frais_suple), params: { frais_suple: { facturation: @frais_suple.facturation, montant: @frais_suple.montant, references: @frais_suple.references, type: @frais_suple.type } }, as: :json
    assert_response 200
  end

  test "should destroy frais_suple" do
    assert_difference('FraisSuple.count', -1) do
      delete frais_suple_url(@frais_suple), as: :json
    end

    assert_response 204
  end
end
