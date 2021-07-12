require 'test_helper'

class CautionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @caution = cautions(:one)
  end

  test "should get index" do
    get cautions_url, as: :json
    assert_response :success
  end

  test "should create caution" do
    assert_difference('Caution.count') do
      post cautions_url, params: { caution: { montant: @caution.montant, references: @caution.references, type_de_payment: @caution.type_de_payment } }, as: :json
    end

    assert_response 201
  end

  test "should show caution" do
    get caution_url(@caution), as: :json
    assert_response :success
  end

  test "should update caution" do
    patch caution_url(@caution), params: { caution: { montant: @caution.montant, references: @caution.references, type_de_payment: @caution.type_de_payment } }, as: :json
    assert_response 200
  end

  test "should destroy caution" do
    assert_difference('Caution.count', -1) do
      delete caution_url(@caution), as: :json
    end

    assert_response 204
  end
end
