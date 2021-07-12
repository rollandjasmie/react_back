require 'test_helper'

class EquipementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get equipements_index_url
    assert_response :success
  end

  test "should get create" do
    get equipements_create_url
    assert_response :success
  end

  test "should get update" do
    get equipements_update_url
    assert_response :success
  end

  test "should get delete" do
    get equipements_delete_url
    assert_response :success
  end

end
