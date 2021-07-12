class Photo < ApplicationRecord
  belongs_to :logement
  mount_uploader :photo, PhotoUploader

end
