class ComptaController < ApplicationController
  before_action :authorized, only: [:facture, :recherche, :cordonne_facture, :cordonne_facture_update]

  #facture filtre par mois
  def facture
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end

    user = current_user
    logement = Logement.find(params[:logement_id])
    factures = nil

    janvier = []
    fevrier = []
    mars = []
    avril = []
    mai = []
    juin = []
    juillet = []
    aout = []
    septembre = []
    octobre = []
    novembre = []
    decembre = []
    year = nil

    if params[:year]
      year = params[:year].to_i
    else 
      year = Date.today.year
    end
      if logement.facture_versements
        logement.facture_versements.each do |fact|
          if fact.created_at.year == year && fact.statut == "Terminé"
            case fact.created_at.month  
            when 1
              janvier  << fact
            when 2
              fevrier  << fact
            when 3
              mars  << fact
            when 4
              avril  << fact
            when 5
              mai  << fact
            when 6
              juin  << fact
            when 7
              juillet  << fact
            when 8
              aout  << fact
            when 9
              septembre  << fact
            when 10
              octobre  << fact
            when 11
              novembre  << fact
            when 12
              decembre  << fact
            end
          end
            
        end
      end

      render json:{
        janvier:janvier,
        fevrier:fevrier,
        mars:mars,
        avril:avril,
        mai:mai,
        juin:juin,
        juillet:juillet,
        aout:aout,
        septembre:septembre,
        octobre:octobre,
        novembre:novembre,
        decembre:decembre,
      }
  end
  def recherche #un facture
    logements= Logement.find(params[:logement_id])
    factures = logements.facture_versements
    recherche =  params[:recherche]
    resultat = []

      factures.each do |facture|
        if facture.numreservation.downcase.include?(recherche.downcase) || facture.user.name.downcase.include?(recherche.downcase) || facture.user.first_name.downcase.include?(recherche.downcase) || facture.user.email.downcase.include?(recherche.downcase)
          resultat << facture
        end
      end
      if resultat.present?
        render json:{
          resultat:resultat
        }
      else
          render json:{
          resultat:nil
        }
      end
      
  end
  

  def cordonne_facture#profil propriétaire
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    user = current_user
    logement = Logement.find(params[:logement_id])
    if user.id == logement.user_id
      render json:{
        ville: user.ville,
        departement: user.departement,
        codepostal: user.codepostal,
        name: user.name,
        first_name: user.first_name,
        adresse: user.adresse
        }
    end
    
  end
  def cordonne_facture_update
    logement = Logement.find(params[:logement_id])
    user = logement.user
     if user.update(ville: params[:ville], departement: params[:departement],codepostal: params[:codepostal],name: params[:name],first_name: params[:first_name],
        adresse: params[:adresse])
      render json:{
        user: :"OK",
        }
    else 
       render json:{
        user: :"error",
        }
    end
    
  end

  #coordonnée baincaire
  def cordonne_bancaire
     if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
      end
    logement = Logement.find(params[:logement_id])
    user = logement.user
    if user == current_user
      coordone = CoordoneBancaire.find_by(user_id: current_user.id)
      render json:{coordone:coordone}
    elsif  current_user.has_attribute?(:admin)
      coordone = CoordoneBancaire.find_by(user_id: current_user.id)
      render json:{coordone:coordone}
    end
    
  end
  #envoyer un code avec un adresse email
  def send_code
    code = rand(1111...9999)
     if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
      end
    logement = Logement.find(params[:logement_id])
    user = logement.user
    if user == current_user
      CoordoneBancaire.find_by(user_id:user.id).update(code:code)
      SendCodeBancaireMailer.code(user,code).deliver_now
      render json:{code:"code envoyé"}
    end   
    
  end
  def cofirm_code
      if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
      end
    logement = Logement.find(params[:logement_id])
    user = logement.user
    if user == current_user &&  params[:code]
     code = CoordoneBancaire.find_by(user_id:user.id).code
      
      if code == params[:code].to_i
        render json:{message:"code valid"}
      else
        render json:{message:"code invalid"}
      end
      
    end
  end
  
  
  def update_cordonne_bancaire
     if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
      end
    logement = Logement.find(params[:logement_id])
    user = logement.user
    if user == current_user
      CoordoneBancaire.find_by(user_id:user.id).update(params_bancaire)
    end
  end
  
  private
  
  def params_bancaire
    params.permit(:numero,:mois,:year,:CVC, :titulaire)
  end
end
