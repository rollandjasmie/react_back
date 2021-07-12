class Admin::AdminRunController < ApplicationController
      before_action :authorized, only: [:index, :update, :delete]
      before_action :set_paper_trail_whodunnit

    # Authentification d'un admin 
    def login
      admin = AdminRun.find_by(email: params[:email])
        if(admin)
          if admin.statu == "en pause"
            # si le statut d'un admin est en pause 
            render json: {status:"en pause"}
          else
            #  si le statut d'un admin est actif  
            if admin && admin.authenticate(params[:password])
                token = encode_token({user_id: admin.id,admin:true})
                render json: {user: {
                   admin: admin.admin,
                    adresse: admin.adresse,
                    email: admin.email,
                    first: admin.first,
                    id: admin.id,
                    mobile: admin.mobile,
                    name: admin.name,
                    niveau: admin.niveau,
                    pseudo:admin.pseudo,
                    statu:admin.statu,
                }, token: token}
            else
                render json: {error: "Mot de passe ou email incorrect"}
            end
          end
        else
          render json: {error:"admin not found"}, status: 404
        end 
    end



    # liste de tous les admins
    def index
        admins = []
        AdminRun.all.each do |admin|
          next if admin.email == "test@testgmail.com"
          admins << admin
        end
        
        if admins.present?
          render json:{
             admins:admins
         }
        end
        
    end


    # affichage d'un profil (admin)  
    def show
        admin = AdminRun.find(params[:admin_id])
         render json:{
            admin:admin
        }
    end

    #  mia à jours d'un profil (admin) 
    def update
      # admin_a = ancien profile
      # admin_n = nouveau profile
      # admins = tous les admins


      admin_a = AdminRun.find(params[:admin_id])
      email = params[:email]
      admins = []

      AdminRun.all.each do |admi|
          next if admi.email == admin_a.email
          admins << admi.email
      end
      # vérification si le nouveau mail est déjà existé
      if admins.include?(email)
          render json: {
              statu:"Email déjà existé"
          }   
      else
        #mis à jours
          AdminRun.find(params[:admin_id]).update(name:params[:name],first:params[:first],adresse:params[:adresse],mobile:params[:mobile],email:params[:email],niveau:params[:niveau],statu:params[:statu],pseudo:params[:pseudo])
          admin_n = AdminRun.find(params[:admin_id])
        
          # création d'une historique( modification )
          if admin_a.niveau != admin_n.niveau
            Historique.create(pseudoadmin: current_user.admin, prorietaire: admin_n.pseudo, action: "Modification - admin - Niveau d’accréditation en #{admin_n.niveau}", admin_run_id: current_user.id)
          end
          if admin_a.statu != admin_n.statu
            Historique.create(pseudoadmin: current_user.admin, prorietaire: admin_n.pseudo, action: "Modification - admin - Statut  #{admin_n.statu}", admin_run_id: current_user.id)
          end
          if admin_a.name != admin_n.name || admin_a.first != admin_n.first || admin_a.adresse != admin_n.adresse || admin_a.mobile != admin_n.mobile || admin_a.email != admin_n.email || admin_a.pseudo != admin_n.pseudo 
            Historique.create(pseudoadmin: current_user.admin, prorietaire: admin_n.pseudo, action: "Modification - admin -Profil", admin_run_id: current_user.id)
          end
          render json: {
              statu:"OK"
          }
      end
    end
    
    #recheche d'un profil(admin)
    def recherche
      admin_r = params[:admin_r].downcase
      admins = []
      AdminRun.all.each do |admin|
        if admin.pseudo.downcase.include?(admin_r) ||  admin.name.downcase.include?(admin_r) ||  admin.first.downcase.include?(admin_r) || admin.email.downcase.include?(admin_r) || admin.mobile.downcase.include?(admin_r) || admin.niveau.downcase.include?(admin_r) ||  admin.statu.downcase.include?(admin_r)
          admins << admin
        end
      end
      if admins.present?
        render json:{
            admins: admins,
        }
      else
        render json:{
            admins:nil
          }
      end 
    end
    
    #création d'un admin
    def create
      admin = AdminRun.find_by(email: params[:email])
      if admin
        render json:{
          statu:"Email déjà existé"
        }
      else
        admin = AdminRun.new(name:params[:name],first:params[:first],adresse:params[:adresse],mobile:params[:mobile],email:params[:email],niveau:params[:niveau],statu:params[:statu],pseudo:params[:pseudo],password:params[:password])
        if admin.valid?
            admin.save

      # création d'une historique (création admin)
            Historique.create(pseudoadmin: current_user.admin, prorietaire: admin.pseudo, action: "Création -admin", admin_run_id: current_user.id)
            render json: {statu: "succes"}
        else
            render json: {error: "Mot de passe ou email incorrect"}
        end
      end
    end
    #Effacer un admin
    def delete
        admin =  AdminRun.find(params[:admin_id])
        admin_a = admin.pseudo
        if admin.destroy
          # création d'une historique( effacement )

            Historique.create(pseudoadmin: current_user.admin, prorietaire: admin_a, action: "Suppression - Admin", admin_run_id: current_user.id)
            render json: :"effacer"
        end
    end

    # envoyer un mail pour le mot de passe oublié 
    def password
      admin = AdminRun.find_by(email:params[:email])
      if admin
          PasswordMailer.admin(admin).deliver_now
      end
    end
  
    # nouveau mot de passe  à partir d'un mot de passe oublié
    def new_password

      #decryptage d'email 
        email=Base64.decode64(params[:id])

      new_pasword = params[:password]
      
      time =params[:time]
      
      #time_exp = temps d'expiration pour le mail envoyer encas de mot de passe oublié
      time_exp = DateTime.parse(time) + 1.hour

        user = AdminRun.find_by(email:email)
        if user
      #vérification si le temps est expiré
            if time_exp >= Time.now
                user.update(password:new_pasword)
                render json: {lien: :"OK"}
            else
                render json: {lien: :"Lien expiré"}
            end
        end
        
    end

    def user_params
        params(:admin_run).permit(:name,:first,:adresse,:mobile,:email,:password,:niveau,:statu,:pseudo)
    end
    
end
