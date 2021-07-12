require 'test_helper'

class ParmsReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parms_reservation = parms_reservations(:one)
  end

  test "should get index" do
    get parms_reservations_url, as: :json
    assert_response :success
  end

  test "should create parms_reservation" do
    assert_difference('ParmsReservation.count') do
      post parms_reservations_url, params: { parms_reservation: { autre: @parms_reservation.autre, references: @parms_reservation.references, title: @parms_reservation.title } }, as: :json
    end

    assert_response 201
  end

  test "should show parms_reservation" do
    get parms_reservation_url(@parms_reservation), as: :json
    assert_response :success
  end

  test "should update parms_reservation" do
    patch parms_reservation_url(@parms_reservation), params: { parms_reservation: { autre: @parms_reservation.autre, references: @parms_reservation.references, title: @parms_reservation.title } }, as: :json
    assert_response 200
  end

  test "should destroy parms_reservation" do
    assert_difference('ParmsReservation.count', -1) do
      delete parms_reservation_url(@parms_reservation), as: :json
    end

    assert_response 204
  end
end
