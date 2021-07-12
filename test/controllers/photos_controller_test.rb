require 'test_helper'

class PhotosControllerTest < ActionDispatch::IntegrationTest
  test "photos upload" do
    test_image = '../fixtures/files' + "/Test.png"
    file = Rack::Test::UploadedFile.new(test_image, "image/png")
    post "/logements/2/photos", :photo => { :photo => file }
    # assert desired results   
  
    assert_response 204
    assert_response :success
  end
end
