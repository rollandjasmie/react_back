class ConversationClientsController < ApplicationController
  before_action :authorized, only: [:index, :create]
  before_action :set_conversation, only: [:show, :update, :destroy]
  

  # GET /conversations
  def index
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    conversations = Conversation.all
    @conversation_logement =[]
    @conversation_id = []
    @message = []
    conversations.each do |conversation|
      logement = conversation.logement_id
      log = Logement.find(logement)
      if log.user_id != current_user.id
        if conversation.user_id == current_user.id
          @conversation_logement << conversation.logement
          @conversation_id << conversation
          if conversation.messages.present?
            @message << conversation.messages
          end
        end
      end
    end

    
    if @conversation_logement.present?
      render json:{
      conversation_logement: @conversation_logement,
      conversation_id:@conversation_id,
      message:@message
    }
      
    else
      render json:{
      conversation_logement: @conversation_logement,
      conversation_id:nil
    }
    end
    
  end


  # POST /conversations
  def create
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    if Conversation.where(user_id:current_user.id,logement_id:params[:logement_id]).empty?

      conversation = Conversation.create(user_id:current_user.id,logement_id:params[:logement_id])     
    else
        conversation = Conversation.find_by(user_id:current_user.id,logement_id:params[:logement_id])
    end
      render json:{
        converasation:conversation
      }
  end
 

end
