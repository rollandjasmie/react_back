class Recherche::RechemessageController < ApplicationController
    before_action :authorized, only: [:index, :index_client, :non_lit_client]
    
    # recherche un voyageur dans le parite message
    def index 
        name=[:name]
        # @user = User.where("name = #{params[:name]} or first_name = #{params[:name]}")
         @users = User.where(["name  LIKE ? or first_name LIKE ?", "#{params[:name]}", "#{params[:name]}"])
         resultat=[]
         resultat_user=[]
         User.all.each do |user|
            if user.conversations
                user.conversations.each do |conv|
                    if conv.logement_id == params[:logement_id].to_i &&  user.name.downcase.include?(params[:name].downcase) ||  user.first_name.downcase.include?(params[:name].downcase)
                        resultat << conv
                        resultat_user << user
                    end
                
                end
            end
            
        end
        
        if resultat.present?
            
            
            render json:{
                resultat: resultat,
                resultat_user:resultat_user
            }
        else
            render json:{
                    resultat:nil
                }
            
        end
    end

    # recherche un propriétaire dans le parite message

    def index_client 
        # Block execution if there is no current user
        if(current_user.blank?)
            return render json:{
            errors: "true",
            message: "User not connected"
            }, status: 401
        end
        name=[:name]
        # @user = User.where("name = #{params[:name]} or first_name = #{params[:name]}")
         @logements = Logement.where("name LIKE ? ", "%#{params[:name]}%")
         #resultat de la recherche et le logement qui concerné
         resultat=[]
         resultat_logement=[]
         @logements.each do |logement|
            if logement.conversations
                logement.conversations.each do |conv|
                    if conv.user_id == current_user.id
                        resultat << conv
                        resultat_logement << logement
                    end
                
                end
            end
            
        end
        
        if resultat.present?
            
            
            render json:{
                resultat: resultat,
                resultat_logement:resultat_logement
            }
        else
            render json:{
                    resultat:nil
                }
            
        end
    end
    #message non lu par le voyageur
    def non_lit_client
        # Block execution if there is no current user
        if(current_user.blank?)
            return render json:{
            errors: "true",
            message: "User not connected"
            }, status: 401
        end
        user = current_user
        conversations = user.conversations
        non_repondus_conv = []
        non_repondus_log = []
        if conversations
            conversations.each do |conversation|
                
                 
                    if conversation.messages.present? && conversation.messages.last.is_client != user.id
                        non_repondus_conv << conversation
                        non_repondus_log << conversation.logement
                
                    end
            end
        end
        
        if non_repondus_conv.present?
            render json:{
                non_repondus_conv:non_repondus_conv,
                non_repondus_log:non_repondus_log
            }
        end
        
        
    end
    
    
end
