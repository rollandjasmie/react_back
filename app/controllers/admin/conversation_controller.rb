class Admin::ConversationController < ApplicationController
  before_action :authorized, only: [:index, :show, :create, :destroy]
  before_action :set_conversation, only: [:show, :update, :destroy]
  

  #toutes les messages entre l'admin et le proriétaire(propriétaire d'un logement) et
  #modification d'une message non lu en lu
  def index
  #tous les messages
  message = nil
  #un conversation
  conver = []

    if ConverAdmin.find_by(logement_id:params[:logement_id]).present?

      conversation = ConverAdmin.find_by(logement_id:params[:logement_id])
      conver << {conversation:conversation,proprietaire:conversation.logement.user.name}

      if conversation.message_admins.present?
        message = conversation.message_admins
        conversation.message_admins.where('read =? and is_admin != ?',false, 1).each do |message|
          message.update(read:true)
        end
      end
    else
      conversation = ConverAdmin.create(admin_run_id: 1, logement_id: params[:logement_id])
      conver << conversation
    end
    
    render json:{
      conver:conver,
      messages: message
    }
  end

  # GET /conversations/1
  def show
    render json: @conversation
  end

  # POST /conversations
  def create
    if Conversation.where(user_id:2,logement_id:params[:logement_id]).empty?

      conversation = Conversation.create(user_id:2,logement_id:params[:logement_id])     
    else
        conversation = Conversation.find_by(user_id:2,logement_id:params[:logement_id])
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
