class ConversationsController < ApplicationController
  before_action :authorized, only: [:index, :show, :non_repondu, :create, :destroy]
  before_action :set_conversation, only: [:show, :update, :destroy]
  

  # GET /conversations
  def index
    conversations = Conversation.all
    @conversation_user =[]
    @conversation_id = []
    @message = []
    conversations.each do |conversation|
      
      if conversation.logement_id == params[:logement_id].to_i 
        @conversation_user << conversation.user
        @conversation_id << conversation
        
        if conversation.messages.present?
          @message << conversation.messages
          
        end
        
        
      end
      
      
    end

    
    if @conversation_user.present?
      render json:{
      conversation_user: @conversation_user,
      conversation_id:@conversation_id
    }
      
    else
      render json:{
      conversation_user: @conversation_user,
      conversation_id:nil
    }
    end
    
  end

  # GET /conversations/1
  def show
    render json: @conversation
  end
  # GET /message non repondu

  def non_repondu
    conversations = Conversation.all
    @conversation_user =[]
    @conversation_id = []

      conversations.each do |conversation|
      if conversation.logement_id == params[:logement_id].to_i 
        if conversation.messages.last.is_client == true
          @conversation_user << conversation.user
          @conversation_id << conversation
        end
      end
    end
    if @conversation_user.present?
        render json:{
        non_repondu_user: @conversation_user,
        non_repondu_conversation_id:@conversation_id
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
