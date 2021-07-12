class Conversation < ApplicationRecord
     belongs_to :logement
     belongs_to :user
     has_many :messages, dependent: :destroy
end
