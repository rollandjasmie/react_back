class AdminRun < ApplicationRecord
    has_secure_password
    validates_presence_of :email
    validates_uniqueness_of :email
    has_paper_trail on: [:update]

    has_many :conver_admins
    has_many :logements, through: :conver_admins
end
