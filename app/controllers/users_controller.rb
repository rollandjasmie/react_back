class UsersController < ApplicationController
    before_action :authorized, only: [:show, :update]

    #afficher le profil d'utitlisateur dans son tableau de bord
    def show
        # Block execution if there is no current user
        if(current_user.blank?)
            return render json:{
            errors: "true",
            message: "User not connected"
            }, status: 401
         end
        show= User.find_by(id:current_user.id)
        #atta = photo de profil
        atta = show.featured_image.attached?
        if atta 
            avatar = rails_blob_path(show.featured_image)
            render json:{
                user:show,avatar:avatar,photo:atta
            }
        else 
            render json:{
                user:show,photo:atta
            }
        end
    end

    def create
        @user = User.find_by(email: params[:email])
        if @user
            render json:{
                success: "false",
                message:"Email déjà existé"
            },  status: :conflict
        else
            
            @user = User.new(user_params)
            @user.iduser = "#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}"
            if @user.save
                # Don't need to generate token after register because user need to confirme his account first
                # token = encode_token({user_id: @user.id  })
                ConfirmationMailer.send_confirmation(@user).deliver
                render json: {
                    success: "true", 
                    message: "User created successfully", 
                    data: {
                        id: @user.id,
                        email: @user.email,
                        name: @user.name,
                        first_name: @user.first_name,
                        adresse: @user.adresse,
                        mobile: @user.mobile,
                        date_of_birth: @user.date_of_birth,
                        sexe: @user.sexe,
                        is_client: @user.is_client
                    }
                }, status: :created

            else
                render json: {
                    success: "false", 
                    errors: @user.errors.messages
                }, status: :bad_request

            end
        end
    end

    def login
        @user = User.find_by(email: params[:email])
        if @user && @user.confirmed_at
            if @user && @user.authenticate(params[:password])
                @user.update(is_client:params[:is_client])
                token = encode_token({user_id: @user.id,admin:false})
                render json: {
                    user: {
                        id: @user.id,
                        email: @user.email,
                        name: @user.name,
                        first_name: @user.first_name,
                        adresse: @user.adresse,
                        mobile: @user.mobile,
                        date_of_birth: @user.date_of_birth,
                        sexe: @user.sexe,
                        urgence: @user.urgence,
                        created_at: @user.created_at,
                        is_client: @user.is_client,
                        piece: @user.piece,
                        codepostal: @user.codepostal,
                        ville: @user.ville,
                        departement: @user.departement,
                        iduser: @user.iduser 
                    },
                    token: token
                }
            else
                render json: {
                    success: "false", 
                    message: "Mot de passe ou email incorrect"
                }
            end
        else
            return render json: {
                success: "false",
                message: 'please validate your account'
            }
        end 
    end

    def update
       @users =User.find_by(id:current_user.id)
        if @user.save
            @users.update(user_params)
        else
            render json: {user:@user.errors.messages}
        end

    end
    
    #envoyer une invitaion pour devenir une cogestionniare
    def invitaiton_send
        # Block execution if there is no current user
        if(current_user.blank?)
            return render json:{
            errors: "true",
            message: "User not connected"
            }, status: :unauthorized
        end
        user = User.find_by(email:params[:email])

        log = Logement.find(params[:logement_id])
        
        #propriétaie du logment 
        currentu = log.user
        if user && currentu.email != params[:email]
            #toutes les cogestionniare existe 
            cogestion = log.cogestion    
            if cogestion.include?(user.id)
                render json:{resultat: "déjà co-hôte"}
            else
                logement = params[:logement_id]
                UserMailer.welcome_email(user,logement,currentu).deliver_now

                if current_user.has_attribute?(:admin)
                    Historique.create(pseudoadmin: current_user.pseudo, prorietaire: log.idlogement, action: "Envoyer une invitaion - co-gestionnire", admin_run_id: current_user.id)
                end
            end
        end
    end

    #invitaion accepté
    def invitation_accepte
        id_l = params[:logement_id]
        id_u = params[:user_id]
        l = Base64.decode64(id_l).to_i
        uc = Base64.decode64(id_u).to_i
        date = Date.parse(Base64.decode64(params[:date]))
        today = Date.today
        logement = Logement.find(l) 
        cogestion = logement.cogestion
        if date < today
            render json:{reponse:"Invitaion expiré!!!.
            Veuillez démander au propriétaire de vous renvoyer l'invitation"}
        else
            if cogestion.present?
                if cogestion.include?(uc)
                    render json:{reponse:"invitaion déjà accepté"}
                else
                    cogestion << uc
                    logement.update(cogestion:cogestion)
                    render json:{reponse:"invitaion  accepté"}
    
                end
            else
                logement.cogestion=[uc]
                logement.save
                render json:{reponse:"invitaion  accepté"}
            end
        end

    end

    #afficher le profil du propriétaire en-dessous de son logement dans l'annonce
    def profil
        logement = Logement.find(params[:logement_id])
        show = logement.user
          atta = show.featured_image.attached?
        if atta 
            avatar = rails_blob_path(show.featured_image)
            render json:{
                user:{name:show.name,first_name:show.first_name,created_at:show.created_at},avatar:"#{ENV["SERVER_URL"]}#{avatar}",photo:atta
            }
        else 
            render json:{
                user:{name:show.name,first_name:show.first_name,created_at:show.created_at},photo:atta
            }
        end
    end
    
    # def auto_login
    #     render json: @user
    # end
    #envoyer un mail de récuration du compte
    def password
        user = User.find_by(email:params[:email])
        if user && user.confirmed_at
            PasswordMailer.welcome_email(user).deliver_now
        end
    end
    
    def new_password#nouveua mot de passe
        email=Base64.decode64(params[:id])
        new_pasword = params[:password]
        time =params[:time]
        time_exp = DateTime.parse(time) + 1.hour

        user = User.find_by(email:email)
        if user
            if time_exp >= Time.now
                user.update(password:new_pasword)
                render json: {lien: :"OK"}
            else
                render json: {lien: :"Lien expiré"}
            end
        end
    end

    #confirmation 'dun compte
    def confirm
        token = params[:token].to_s
        user = User.find_by(confirmation_token: token)
        if user.present? && user.confirmation_token_valid?
            user.mark_as_confirmed!
            #création coordonné  bancaire
            CoordoneBancaire.create(user_id:user.id,titulaire:"#{user.first_name}#{" "}#{user.name}")
            # render json: {status: 'User confirmed successfully'}
          redirect_to ENV["CLIENT_URL"] # <-- redirect to the client domain name
        else
            render json: {status: 'Invalid token'}
        end
    end
    
    private
    def user_params
        params.permit(:id,:name,:first_name,:adresse,:mobile,:date_of_birth,:sexe,:urgence,:email,:is_client,:piece,:password,:featured_image)
    end
end
