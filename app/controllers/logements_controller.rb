class LogementsController < ApplicationController
    before_action :authorized, only: [:create, :index, :update]

    def index# liste touts les logements dans le tableau de bord d'un propriétaires

        # Block execution if there is no current user
        if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
        end
        user = User.find(current_user.id)
        logements = Logement.all
        logement = []

        reservations_arr = []
        reservations_dep = []

        #interval de temps aujourd'hui et démain
        dateDemain = Date.today + 1
        date = Date.today
        table_date = (date..dateDemain).to_a

        #message non lu (voyageurs)
        tp=[]

        #message non lu (admin)
        admin =[]
        
        #user = current_user
        logements.each do |logs|
            if logs.user_id == user.id 
                logement << logs
                #table_date =  interval de temps aujourd'hui et démain
                #vérification des réservations 
                table_date.each do |dat|
                     reservations_arr << logs.reservations.where(arrivee: dat, status: "accepter")
                     reservations_dep << logs.reservations.where(depart: dat, status: "accepter")
                end
                 #message non lu (voyageurs)
                if logs.conversations.present?
                    logs.conversations.each do |conver|
                        if conver.messages.last && conver.messages.last.is_client == true && conver.messages.last.read == false
                            tp << {mes:conver.messages.last,log:logs}
                        end
                    end
                end
                
                #message non lu (admin)
                if logs.conver_admin.present?
                    if logs.conver_admin.message_admins.last
                        if logs.conver_admin.message_admins.last.is_admin != logs.id && logs.conver_admin.message_admins.last.read == false
                            admin << {admin:logs.conver_admin.message_admins.last,logs:logs}
                        end
                    else
                        admin << {admin:0,logs:logs}
                    end
                else
                    admin << {admin:0,logs:logs}
                end
                
            end

            #pour le co-hote
            
            if logs.cogestion.present?
                if logs.cogestion.include?(user.id)
                    logement << logs
                    #table_date =  interval de temps aujourd'hui et démain
                    #vérification des réservations 
                    table_date.each do |dat|
                        reservations_arr << logs.reservations.where(arrivee: dat, status: "accepter")
                        reservations_dep << logs.reservations.where(depart: dat, status: "accepter")
                    end
                 #message non lu (voyageurs)

                    if logs.conversations.present?
                        logs.conversations.each do |conver|
                            if conver.messages.last && conver.messages.last.is_client == true && conver.messages.last.read == false
                                tp << {mes:conver.messages.last,log:logs}
                            end
                        end
                    end
                     #message non lu (admin)
                if logs.conver_admin.present?
                    if logs.conver_admin.message_admins.last
                        if logs.conver_admin.message_admins.last.is_admin != logs.id && logs.conver_admin.message_admins.last.read == false
                            admin << {admin:logs.conver_admin.message_admins.last,logs:logs}
                        end
                    else
                        admin << {admin:0,logs:logs}
                    end
                else
                    admin << {admin:0,logs:logs}
                end
                end
            end
            
                    
           
            
        end
        if logement.present?

            # logement = logement.order(:id)

        end
        
        indexa=[]
        adresses=[]
        photos=[]
        reserv1 = reservations_dep.flatten
        reserv2 = reservations_arr.flatten

        logement.each do |indexz|
            indexa << indexz

            adresse = indexz.adresse

            adresses << adresse
            photos << indexz.photos[0]
            end     

            
            render json: {
                        logement:indexa,
                        adresse:adresses,
                        photos:photos,
                        arrivee: reserv2,
                        depart: reserv1,
                        message:tp,
                        admin:admin
                    }            
    end
    def show#afficher l'adresse d'un logement
        logement = Logement.find(params[:id])
        adresse = logement.adresse.adresse
        render json:{
            logement:logement,
            adresse:adresse
        }
        
    end
    
    
    def create#création d'un logement et tous les objet qui liés à lui

        # Block execution if there is no current user
        if(current_user.blank?)
            return render json:{
            errors: "true",
            message: "User not connected"
            }, status: 401
        end

        
        logement= params[:hebergement]
        logement= JSON.parse(logement)
        adresse= params[:localisation]
        adresse= JSON.parse(adresse)
        photos = params[:photo]
        if logement["name"].present? &&  logement["types"].present? && logement["categorie"].present? && adresse["pays"].present? && adresse["ville"].present? &&adresse["adresse"].present? && adresse["code"].present? &&  params[:photo].count > 0
            #id du logement
            id = nil
            if Logement.last
                id = Logement.last.id+1
            end
            #pour eviter de commencer l id d'un logement à 1
            if id != nil
                @logement = Logement.new(id:id,name:logement["name"],status:true,types:logement["types"],categorie:logement["categorie"],idlogement:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}")
            elsif id == nil
                @logement = Logement.new(id:2,name:logement["name"],status:true,types:logement["types"],categorie:logement["categorie"],idlogement:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}")
            end
            @logement.user_id = current_user.id
            @logement.save

            #taxe 
            TaxeDeSejour.create(logement_id:@logement.id)
                
            #piece
            @chambre = Chambre.create(title:"Chambre",logement_id: @logement.id)
            @bain_entier = BainEntier.create(title:"Salle de bain entière : Toilette, lavabo, douce et baignoire
            ",quantite: params[:quantite],logement_id: @logement.id)
            @bain_demi = BainDemi.create(title:"Demi-salle de bain : Toilette et lavabo
            ",quantite: params[:quantite],logement_id: @logement.id)
            @cuisine = Cuisine.create(title:"Cuisine entière
            ",quantite: params[:quantite],logement_id: @logement.id)
            @kitchenette = Kitchenette.create(title:"Kitchenette : un espace compact pour préparer à manger
            ",quantite: params[:quantite],logement_id: @logement.id)


            #adresse
            adresse= params[:localisation]
            adresse= JSON.parse(adresse)
            @adresse = Adresse.new(pays:adresse["pays"],ville:adresse["ville"],adresse:adresse["adresse"],code:adresse["code"])
            @adresse.logement_id = @logement.id
            @adresse.save
            
            
            
            #map controller new
            mape= params[:map]
            mape= JSON.parse(mape)
            @map = Map.new(longitude:mape["longitude"],latitude:mape["latitude"],zoom:mape["zoom"])
            @map.logement_id = @logement.id
            @map.save

            #nombre de personne minimum
            nombre = params[:personne]
            nombre = JSON.parse(nombre) 
            @nombre = Nombrepersonne.new(number:nombre)
            @nombre.logement_id = @logement.id
            @nombre.save
            

            #canapé
            canapes = params[:canapes]
            canapes= JSON.parse(canapes)

            @salon_id=nil
            canape_lit = nil

            canapes.each do |canape|
                if canape["checked"] == true && canape["name"] == "Canapés"
                    
                        salon = Salon.create(title: "Salon",logement_id: @logement.id)
                        @salon_id=salon.id
                        canape = Canape.new(name:"Canapés",quantite:canape["quantite"],checked:canape["checked"])
                        canape.salon_id = salon.id
                        canape.save 

                        canape_lit = Canape.new(name:"Canapés lits",quantite:0,checked:false)
                        canape_lit.salon_id = salon.id
                        canape_lit.save 

                elsif canape["checked"] == true && canape["name"] == "Canapés lits"
                        
                        if @salon_id.present?
                            id=canape_lit.id
                            cap =Canape.fin(id)
                            cap.update(name:"Canapés lits",quantite:canape["quantite"],checked:canape["checked"])
                        
                        else
                            salon = Salon.create(title: "Salon",logement_id: @logement.id)
                            canape = Canape.new(name:"Canapés lits",quantite:canape["quantite"],checked:canape["checked"])
                            canape.salon_id = salon.id
                            canape.save

                            canape_lits = Canape.new(name:"Canapés",quantite:0,checked:false)
                            canape_lits.salon_id = salon.id
                            canape_lits.save  
                        end
                        
                end
                
            end
            
            #autre espace
            autres = params[:autres]
            autres= JSON.parse(autres)

            @autre_id=nil

            @autred = nil
            @autred01 = nil

            @autre01 = nil
            @autre02 = nil

            autres.each do |autre|           
                if autre["checked"] == true && autre["name"] == "Lit Simple"
                    
                        new_autre = Autre.create(title: "Autre espace",logement_id: @logement.id)
                        @autre_id = new_autre.id
                        autre_esace_lit = Autrelit.new(name:autre["name"],quantite:autre["quantite"],checked:autre["checked"])
                        autre_esace_lit.autre_id = new_autre.id
                        autre_esace_lit.save 

                        @autre01= Autrelit.new(name:"Lit Double",quantite:0,checked:false)
                        @autre01.autre_id = new_autre.id
                        @autre01.save

                        @autre02 = Autrelit.new(name:"Lit Famille",quantite:0,checked:false)
                        @autre02.autre_id = new_autre.id
                        @autre02.save 

                elsif autre["checked"] == true && autre["name"] == "Lit Double"
                    
                    if @autre_id.present?
                        id =@autre01.id
                        aut = Autrelit.find(id)
                        aut.update(name:autre["name"],quantite:autre["quantite"],checked:autre["checked"])
                    
                    else
                        new_autre = Autre.create(title: "Autre espace",logement_id: @logement.id)
                        @autred = new_autre.id
                        
                        autre_esace_lit = Autrelit.new(name:autre["name"],quantite:autre["quantite"],checked:autre["checked"])
                        autre_esace_lit.autre_id = new_autre.id
                        autre_esace_lit.save

                        lit_simple = Autrelit.new(name:"Lit Simple",quantite:0,checked:false)
                        lit_simple.autre_id = new_autre.id
                        lit_simple.save 

                        @autred01 = Autrelit.new(name:"Lit Famille",quantite:0,checked:false)
                        @autred01.autre_id = new_autre.id
                        @autred01.save 
                    end
                    

                elsif autre["checked"] == true && autre["name"] == "Lit Famille"
                    
                    if @autre_id.present?
                        id =@autre02.id
                        aut = Autrelit.find(id)
                        aut.update(name:autre["name"],quantite:autre["quantite"],checked:autre["checked"])
                    elsif @autred.present?
                        id = @autred01.id
                        aut = Autrelit.find(id)
                        aut.update(name:autre["name"],quantite:autre["quantite"],checked:autre["checked"])                   
                    else    
                        new_autre = Autre.create(title: "Autre espace",logement_id: @logement.id)
                        lits = Autrelit.new(name:autre["name"],quantite:autre["quantite"],checked:autre["checked"])
                        lits.autre_id = new_autre.id
                        lits.save 

                        lit_double = Autrelit.new(name:"Lit Double",quantite:0,checked:false)
                        lit_double.autre_id = new_autre.id
                        lit_double.save

                        lit_simple = Autrelit.new(name:"Lit Simple",quantite:0,checked:false)
                        lit_simple.autre_id = new_autre.id
                        lit_simple.save 
                    end

                end
            end
            
            # title = params[:title]
            # title= JSON.parse(title)
            # @equipement = Equipement.new(title:title["title"])
            # @equipement.logement_id=@logement.id
            # @equipement.save

            #création des photos
            photos = params[:photo]
            photos.each do |photo|
                photo_new=Photo.new(photo:photo)
                photo_new.logement_id=@logement.id
                photo_new.save!
            end
        
            #paramettre des réservation
            regles = params[:regles]
            regles= JSON.parse(regles)
            ParmsReservation.create(title:regles["regle"],autre:" ",logement_id:@logement.id)
            
            #réglement interieur
            @regle = Regle.new(arrive1:regles["arrive1"],arrive2:regles["arrive2"],depart1:regles["depart1"],depart2:regles["depart2"])
            @regle.logement_id = @logement.id
            @regle.save
            
            #calendrier controller new
            # dates = params[:date]
            # dates= JSON.parse(dates)
            # @cal = Calendrier.new(startDate:dates["startDate"],endDate:dates["endDate"],ouvrir:"yes",tarif:0)

        #création des photos
        photos = params[:photo]
        photos.each do |photo|
            photo=Photo.new(photo:photo)
            photo.logement_id=@logement.id
            photo.save!
        end
    
        #paramettre des réservation
        regles = params[:regles]
        regles= JSON.parse(regles)
        ParmsReservation.create(title:regles["regle"],autre:" ",logement_id:@logement.id)
         
        #réglement interieur
        @regle = Regle.new(arrive1:regles["arrive1"],arrive2:regles["arrive2"],depart1:regles["depart1"],depart2:regles["depart2"])
        @regle.logement_id = @logement.id
        @regle.save
         
         #calendrier controller new
        # dates = params[:date]
        # dates= JSON.parse(dates)
        # @cal = Calendrier.new(startDate:dates["startDate"],endDate:dates["endDate"],ouvrir:"yes",tarif:0)


        #création calendrier
        @cal = Calendrier.new(startDate:Date.today,endDate:Date.today+30,ouvrir:"yes",tarif:45)
        @cal.logement_id = @logement.id
        @cal.save
        
        #conditions d'annulation
        conditions = params[:conditions]
        conditions= JSON.parse(conditions)
        @condition = Condition.new(conditions:conditions["conditions"])
        @condition.logement_id = @logement.id
        @condition.save
        
        #lits pour la chambre
        lits = params[:Lits]
        lits= JSON.parse(lits)
        lits.each do |lit|
               @lits = Lit.new(name:lit["name"],quantite:lit["quantite"],checked:lit["checked"])
               @lits.chambre_id = @chambre.id
               @lits.save     
        end

            #création calendrier
            @cal = Calendrier.new(startDate:Date.today,endDate:Date.new(2030, 12, 12),ouvrir:"yes",tarif:45)
            @cal.logement_id = @logement.id
            @cal.save
            
            #conditions d'annulation
            conditions = params[:conditions]
            conditions= JSON.parse(conditions)
            @condition = Condition.new(conditions:conditions["conditions"])
            @condition.logement_id = @logement.id
            @condition.save
            
            #lits pour la chambre
            lits = params[:Lits]
            lits= JSON.parse(lits)
            lits.each do |lit|
                @lits = Lit.new(name:lit["name"],quantite:lit["quantite"],checked:lit["checked"])
                @lits.chambre_id = @chambre.id
                @lits.save     
            end

            #création des equipement
            title = params[:title]
            title= JSON.parse(title)

            EquiCourant.create(title:title["title"],logement_id: @logement.id)
            EquiFamille.create(title:title["title"],logement_id: @logement.id)
            EquiLogistique.create(title:title["title"],logement_id: @logement.id)
            EquiSecurite.create(title:title["title"],logement_id: @logement.id)
            EquiSuplementaire.create(title:title["title"],logement_id: @logement.id)
            AccesVoyageur.create(acces:" ",aide1:" ",aide2:" ",autre:" ",presentation:" ",transport:" ",logement_id:@logement.id)
            RessouceVoyageur.create(title:" ",logement_id:@logement.id)
            Caution.create(montant:"0",type_de_payment:"Carte bancaire",logement_id: @logement.id)
            render json: {
                message:"succes"
            },status: 200
        else
            render json: {
                message:"Une erreur est survenue. Réessayer à nouveau !"
            }
        end   
    end

    def update#mis à jours d'un logement son nom,types,categorie
        logement = Logement.find_by(id:params[:id])
         if current_user.has_attribute?(:admin)#pour admin
          if logement=logement.update(name:params[:name],types:params[:types],categorie:params[:categorie],description:params[:description],unique:params[:unique],status:params[:status])
            Historique.create(pseudoadmin: current_user.pseudo, prorietaire: Logement.find_by(id:params[:id]).idlogement, action: "Modification -logement -Titre et description", admin_run_id: current_user.id)
            render json: {
              status: :logement,
              logement: Logement.find_by(id:params[:id]),
            }
          else
          render json:{ 
              erreur: :error 
              } 
          end
        else#pour propriétaire
          if logement=logement.update(name:params[:name],types:params[:types],categorie:params[:categorie],description:params[:description],unique:params[:unique],status:params[:status])
              render json: {
                status: :logement,
                logement: Logement.find_by(id:params[:id]),
              }
          else
          render json:{ 
              erreur: :error 
              } 
          end
        end
    end  
end



