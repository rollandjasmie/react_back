class ChambresController < ApplicationController
  before_action :authorized, only: [:create, :update, :deletechambre, :deletesalon, :deleteautre]

  #affichage des chambres,salon,autre espace
    def index
      #nombre de personne maximun pour l'hébegement
       nombre= Nombrepersonne.find_by(logement_id:params[:logement_id])
      if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
         end
      #autres = autres espace 
      user = User.find(current_user.id)
      logement = Logement.find_by(id:params[:logement_id])
      chambres = logement.chambres
      salons = logement.salons
      autres = logement.autres
        
        #tous les lits pour les chambres
        lits = []
        chambres.each do |chambre|
            lits << chambre.lits    
        end

        #tous les canapes pour les salons
        canapes = []
        salons.each do |salon|
            canapes << salon.canapes    
        end

        #tous les lits pour les autres espace
        autreslits = []
        autres.each do |autre|
            autreslits << autre.autrelits
        end

        if (canapes.present? && autreslits.present?)
            render json: {
                chambres:chambres,
                lits:lits,
                logement:logement,
                salons:salons,
                autres:autres,
                canapes:canapes,
                autreslits:autreslits,
                 nombre_personne:nombre.number
            } 
        
        elsif (canapes.present?)
                        render json: {
                chambres:chambres,
                lits:lits,
                logement:logement,
                salons:salons,
                autres:nil,
                canapes:canapes,
                autreslits:nil,
                 nombre_personne:nombre.number
            }
        elsif (autreslits.present?)
                     render json: {
                chambres:chambres,
                lits:lits,
                logement:logement,
                salons:nil,
                autres:autres,
                canapes:nil,
                autreslits:autreslits,
                 nombre_personne:nombre.number
            }
        else
            render json: {
                chambres:chambres,
                lits:lits,
                logement:logement,
                salons:nil,
                autres:nil,
                canapes:nil,
                autreslits:nil,
                 nombre_personne:nombre.number
            }
        end
        
    end
    #création d'une chambre(avec lits),salon(avec canapé) ou autre espace(autre lit) pour un logement
    def create
      

      if current_user.has_attribute?(:admin)#si l'adimn qui fait la création

        logement = Logement.find(params[:logement_id])
        if params[:chambre] && (params[:chambre] != 0 || params[:chambre] != "0") && params[:chambre].present?
          fin = params[:chambre].to_i 
          #crétion d'une chambre
          for i in 0...fin
            chambre_id = Chambre.create(title:"chambre",logement_id:params[:logement_id])
            method_name.each do |valu|
              lits = Lit.create(name:valu,quantite:0,checked:false,chambre_id:chambre_id.id)
            end
          end
          #création d'une historique
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Logement - Ajout chambre", admin_run_id: current_user.id)

        end
          #crétion d'un salon
        if params[:salon] && (params[:salon] != 0 || params[:salon] != "0")
          fin = params[:salon].to_i 
          for i in 0...fin
              salon_id = Salon.create(title:"salon",logement_id:params[:logement_id])
              salon.each do |valu|
                  canapes = Canape.create(name:valu,quantite:0,checked:false,salon_id:salon_id.id)
              end
          end
          #création d'une historique

          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Logement - Ajout salon", admin_run_id: current_user.id)

        end
        #crétion d'une autre espace
        if params[:autre] && (params[:autre] != 0 || params[:autre] != "0")
          fin = params[:autre].to_i 
          for i in 0...fin
            autre_id = Autre.create(title:"Autre espace",logement_id:params[:logement_id])
            salon.each do |valu|
                canapes = Autrelit.create(name:valu,quantite:0,checked:false,autre_id:autre_id.id)
            end
          end
        #création d'une historique

          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Logement - Ajout autre espace", admin_run_id: current_user.id)

        end

      else #si le propriétaire qui fait la création
        if params[:chambre] && (params[:chambre] != 0 || params[:chambre] != "0") && params[:chambre].present?
            fin = params[:chambre].to_i 
            
            for i in 0...fin
                chambre_id = Chambre.create(title:"chambre",logement_id:params[:logement_id])
                    
                method_name.each do |valu|
                    lits = Lit.create(name:valu,quantite:0,checked:false,chambre_id:chambre_id.id)
                end
            end
        end

        if params[:salon] && (params[:salon] != 0 || params[:salon] != "0")
                fin = params[:salon].to_i 
                
                for i in 0...fin
                    salon_id = Salon.create(title:"salon",logement_id:params[:logement_id])
                    
                    salon.each do |valu|
                        canapes = Canape.create(name:valu,quantite:0,checked:false,salon_id:salon_id.id)
                    end
                end
                
        end
        if params[:autre] && (params[:autre] != 0 || params[:autre] != "0")
                fin = params[:autre].to_i 
                
                for i in 0...fin
                    autre_id = Autre.create(title:"Autre espace",logement_id:params[:logement_id])
                    
                    salon.each do |valu|
                        canapes = Autrelit.create(name:valu,quantite:0,checked:false,autre_id:autre_id.id)
                    end
                end
                
        end
      end
   end


   #mis a jour chambre,salon,autre espace et nombre de personnne minimun
  def update
    
    if current_user.has_attribute?(:admin) #pour l'admin
      logement =Logement.find(params[:logement_id])
      if params[:persone] #nombre de personne
        chambre = Chambre.find(params[:id].to_i)
        chambre.update(persone:params[:persone].to_i)
      end
        
      #mis à jours Bain,Cuisine,Kitchenette
        @bain_entier = BainEntier.find_by(logement_id: params[:logement_id])
        if params[:bain_entier]
            @bain_entier.update(quantite: params[:bain_entier])
                                
        end
        @bain_demi = BainDemi.find_by(logement_id: params[:logement_id])
        if params[:bain_demi]
            @bain_demi.update(quantite: params[:bain_demi])
                                
        end
        @cuisine = Cuisine.find_by(logement_id: params[:logement_id])
        if params[:cuisine]
            @cuisine.update(quantite: params[:cuisine])
        end

        @Kit= Kitchenette.find_by(logement_id: params[:logement_id])
        if params[:kitchenette]
            @Kit.update(quantite: params[:kitchenette])
        end


        #mis à jour de lits pour une chambre
        if  params[:lits]
          lits = params[:lits]
            lits.each do |lit|
              if lit["checked"] == false || lit["quantite"] == 0
                    id=Lit.find(lit["id"])
                  id.update(name:lit["name"],checked:false,quantite:0)
              else 
                  id=Lit.find(lit["id"])
                  id.update(name:lit["name"],checked:lit["checked"],quantite:lit["quantite"])
              end
            end
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - chambre", admin_run_id: current_user.id)

        end
        #mis à jour des canapés pour un salon

        if  canapes = params[:canapes]
              canapes.each do |lit|
                if lit["checked"] == false || lit["quantite"] == 0
                      id=Canape.find(lit["id"])
                    id.update(name:lit["name"],checked:false,quantite:0)
                else 
                    id=Canape.find(lit["id"])
                    id.update(name:lit["name"],checked:lit["checked"],quantite:lit["quantite"])
                end
              end
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - salon", admin_run_id: current_user.id)

        end

        #mis à jour des lits pour des autre espace 

        if  autreslits = params[:autreslits]

            autreslits.each do |lit|
              if lit["checked"] == false || lit["quantite"] == 0
                    id=Autrelit.find(lit["id"])
                  id.update(name:lit["name"],checked:false,quantite:0)
              else 
                  id=Autrelit.find(lit["id"])
                  id.update(name:lit["name"],checked:lit["checked"],quantite:lit["quantite"])
              end
            end 
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification - logement - autre espace", admin_run_id: current_user.id)

        end
    else #pour le propriétaire




      if params[:persone] #nombre de personne
        chambre = Chambre.find(params[:id].to_i)
            chambre.update(persone:params[:persone].to_i)
      end

      #mis à jours Bain,Cuisine,Kitchenette
      if params[:kitchenette]
        @Kit= Kitchenette.find_by(logement_id: params[:logement_id])
          @Kit.update(quantite: params[:kitchenette])
      end

      if params[:bain_entier]
        @bain_entier = BainEntier.find_by(logement_id: params[:logement_id])
        @bain_entier.update(quantite: params[:bain_entier])
                                
        end
        if params[:bain_demi]
          @bain_demi = BainDemi.find_by(logement_id: params[:logement_id])
            @bain_demi.update(quantite: params[:bain_demi])
                                
        end
        if params[:cuisine]
          @cuisine = Cuisine.find_by(logement_id: params[:logement_id])
            @cuisine.update(quantite: params[:cuisine])
        end
      
       
        #mis à jour de lits pour une chambre
        if  lits = params[:lits]
              lits.each do |lit|
                if lit["checked"] == false || lit["quantite"] == 0
                      id=Lit.find(lit["id"])
                    id.update(name:lit["name"],checked:false,quantite:0)
                else 
                    id=Lit.find(lit["id"])
                    id.update(name:lit["name"],checked:lit["checked"],quantite:lit["quantite"])
                end
              end 
        end
        #mis à jour des canapés pour un salon
        if  canapes = params[:canapes]
              canapes.each do |lit|
                if lit["checked"] == false || lit["quantite"] == 0
                      id=Canape.find(lit["id"])
                    id.update(name:lit["name"],checked:false,quantite:0)
                else 
                    id=Canape.find(lit["id"])
                    id.update(name:lit["name"],checked:lit["checked"],quantite:lit["quantite"])
                end
              end 
        end

        #mis à jour des lits pour des autre espace
        if  autreslits = params[:autreslits]

            autreslits.each do |lit|
              if lit["checked"] == false || lit["quantite"] == 0
                    id=Autrelit.find(lit["id"])
                  id.update(name:lit["name"],checked:false,quantite:0)
              else 
                  id=Autrelit.find(lit["id"])
                  id.update(name:lit["name"],checked:lit["checked"],quantite:lit["quantite"])
              end
            end 
        end
    end
     
        



  end

  #effacer une chambre
  def deletechambre
      id = params[:id]
      chambre = Chambre.find(id)#pour l'admin
      if current_user.has_attribute?(:admin)
        logement = Logement.find(chambre.logement_id)
        chambre.delete
        render json:{
            supprimé: :"OK"
        }
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Logement - Suppression chambre", admin_run_id: current_user.id)
      else#pour le propriétaire
        chambre.delete
        render json:{
            supprimé: :"OK"
        }
      end
     
  end
    #effacer un salon
  def deletesalon
      id = params[:id]
      chambre = Salon.find(id)
      if current_user.has_attribute?(:admin)#pour l'admin
        logement = Logement.find(chambre.logement_id)
        chambre.delete
        render json:{
            supprimé: :"OK"
        }
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Logement - Suppression salon", admin_run_id: current_user.id)
      else#pour le propriétaire
        chambre.delete
        render json:{
            supprimé: :"OK"
        }
      end
    
  end
      #effacer un autre espace
  def deleteautre
      id = params[:id]
      chambre = Autre.find(id)#pour l'admin
      if current_user.has_attribute?(:admin)
        logement = Logement.find(chambre.logement_id)
        chambre.delete
        render json:{
            supprimé: :"OK"
        }
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Logement - Suppression autre espace", admin_run_id: current_user.id)
      else#pour le propriétaire
        chambre.delete
        render json:{
            supprimé: :"OK"
        }
      end
  
  end
  def method_name
    ["Lit Double","Lit Simple","Lit King-size","Lit Superposé","Canapé lit","Canapé lit double","Futon"]
  end
  def salon
      ["Canapés","Canapés lits"]
  end
end
