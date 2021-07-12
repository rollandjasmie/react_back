class ConverAdminController < ApplicationController
  before_action :authorized, only: [:index, :show, :destroy]
  before_action :set_conversation, only: [:show, :update, :destroy]
  

  # GET /conversations
  def index
    conversations = ConverAdmin.all
    @conversation_admin =[]
    @conversation_id = []
    @message = []
    conversations.each do |conversation|
      if conversation.logement_id == params[:logement_id].to_i 
        @conversation_admin << conversation.admin_run
        @conversation_id << conversation
        if conversation.message_admins.present?
          @message << conversation.message_admins
        end
      end
    end

    render json:{
      conversation_admin: @conversation_admin,
      conversation_id:@conversation_id
    }
  end

  # GET /conversations/1
  def show
    render json: @conversation
  end

  # POST /conversations
  def show
    if ConverAdmin.where(admin_run:1,logement_id:params[:logement_id]).empty?

      conversation = ConverAdmin.create(admin_run:1,logement_id:params[:logement_id])     
    else
        conversation = ConverAdmin.find_by(admin_run:1,logement_id:params[:logement_id])
    end
      render json:{
        converasation:conversation
      }
  end
  
  # DELETE /conversations/1
  def destroy
    @conversation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

end
