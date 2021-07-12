class MessagesController < ApplicationController
    before_action :authorized
  # GET /messages

  def index#affiche des messages entre l'admin et le propriétaire(sur le tableau de bord d'un propriétaire) et modification du statu non lu en lu

    @conversation = Conversation.find(params[:conversation_id])
    @messages = @conversation.messages
    @messages.each do |message|
      if  message.is_client == true
          tmp = message 
          tmp.read = true
          tmp.save  
      end
    end
       render json:{
          messages:@messages
        }
  end
 # pour compter le messages non lu pour un logement
  def count
    logement = Logement.find(params[:logement_id])
    conversations = logement.conversations
    not_read = 0
    
    conversations.each do |conversation|
      if conversation.messages.present? && conversation.messages.last.read == false && conversation.messages.last.is_client != logement.id
        not_read += 1
      end
    end
    
    render json:{
      not_read:not_read
    }
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create#envoyer un message(envoyer par le propriétaire)   
    @conversation = Conversation.find(params[:conversation_id])
    params_value = params.permit(:content, :conversation_id,:is_client,:files)
    @messag = @conversation.messages.new(params_value)
    
    if @messag.save
    @messages = @conversation.messages

      render json:{
        messages:@conversation.messages
      }
    end
    
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end
  #======== nombre de message non lu dans le tableau de bord proprietaire pour tous les logmeents
  def number
    logement = Logement.find_by(id:params[:logement_id])
      tp = []
    if logement.conversations.present?
      logement.conversations.each do |conver|
        if conver.messages.last
          if conver.messages.last.is_client != 1 && conver.messages.last.read == false
            tp << {mes:conver.messages.last,log:conver.logement}
          end
        end
        
      end
    end
    
    if tp.present? 
      render json: {conversation:tp.count,
    logement:logement.id}
      
    else
      render json: {conversation:0,
    logement:logement.id}
      
    end
    
  end
  
  private

                                
    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:content, :references, :references)
    end
end
