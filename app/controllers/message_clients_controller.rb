class MessageClientsController < ApplicationController
  before_action :authorized
  before_action only: [:index,:show, :create] do
    @conversation = Conversation.find(params[:conversation_id])
  end
  # GET /messages
  def index#affiche des messages entre le voyageur et le propriétaire(sur le tableau de bord d'un voyageur) et modification du statu non lu en lu
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    # @messages = Message.all
    logement = @conversation.logement_id
    log = Logement.find(logement)
    if log.user_id != current_user.id
      messages = @conversation.messages
        messages.each do |message|
          if message.is_client == false
            message.update(read:true)            
          end
        end
          render json:{
            messages:messages
          }
    end
    
      
    
  end

  # GET /messages/1
  def show
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end

    @messages = @conversation.messages
    @messages.each do |message|
      # if message.is_client != params[:client_id].to_i
      #     tmp = message 
      #     tmp.read = true
      #     tmp.save
      # end  
     if condition
       
     end
     
      if  message.is_client != current_user.id
          tmp = message 
          tmp.read = false
          tmp.save  
      end
    end
  end

  # POST /messages
  def create#envoyer un message(envoyer par le vyoageur)   
    params_value = params.permit(:content, :conversation_id,:is_client,:files)
    @messag = @conversation.messages.new(params_value)
    if @messag.save
    @messages = @conversation.messages
      render json:{
      messages:@conversation.messages
    }
    end
  end
  def non_lu#afficher le nombre de message non lu (table de bord voyageur)
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    user = current_user
    conversations = user.conversations
    number_message = 0
    if conversations 
      conversations.each do |conversation|
        if conversation.messages.last && conversation.messages.last.is_client == false && conversation.messages.last.read == false
          number_message += 1
        end
      end
    end
    render json:{
      number_message:number_message
    }
    
  end
  
end
