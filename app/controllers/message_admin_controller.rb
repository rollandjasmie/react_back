class MessageAdminController < ApplicationController
    before_action :authorized
  before_action do
    @conversation = ConverAdmin.find(params[:conver_admin_id])
  end
  # GET /messages
  def index#affiche des messages entre l'admin et le propriétaire(sur le tableau de bord d'un admin) et modification du statu non lu en lu
    # @messages = Message.all
    @messages = @conversation.message_admins
    @messages.each do |message|
      if  message.is_admin != params[:logement_id].to_i
          tmp = message 
          tmp.read = true
          tmp.save  
      end
    end
       render json:{
          messages:@messages
        }
      
    
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create#envoyer un message(envoyer par l'admin)   
    params_value = params.permit(:content, :conver_admin_id,:is_admin,:files)
    @messag = @conversation.message_admins.new(params_value)
    if @messag.save
      render json:{
        messages:@conversation.message_admins
      }
    end
    
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

end
