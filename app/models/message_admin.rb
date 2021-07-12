class MessageAdmin < ApplicationRecord
    belongs_to :conver_admin
    mount_uploader :files, FileUploader
  
    # validates_presence_of :content, :conversation_id

  def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end
