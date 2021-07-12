require 'test_helper'

class CommentaireControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get commentaire_index_url
    assert_response :success
  end

  test "should get create" do
    get commentaire_create_url
    assert_response :success
  end

  test "should get delete" do
    get commentaire_delete_url
    assert_response :success
  end

end
