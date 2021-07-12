class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id,:name,:first_name,:adresse,:mobile,:date_of_birth,:sexe,:urgence,:email, :password,:featured_image
  def featured_image
    if object.featured_image.attached?
      {
        url: rails_blob_url(object.featured_image)
      }
    end
  end
end