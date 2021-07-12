class ConverAdmin < ApplicationRecord
     belongs_to :logement, optional: true
     belongs_to :admin_run, optional: true
     has_many :message_admins, dependent: :destroy
end
