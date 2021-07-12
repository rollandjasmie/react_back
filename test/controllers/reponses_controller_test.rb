require 'test_helper'

class ReponsesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get reponses_index_url
    assert_response :success
  end

  test "should get create" do
    get reponses_create_url
    assert_response :success
  end

  test "should get delete" do
    get reponses_delete_url
    assert_response :success
  end

end
