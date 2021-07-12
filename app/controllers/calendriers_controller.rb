class CalendriersController < ApplicationController
  before_action :authorized, only: [:tout, :search, :update]

  #affichage d'une calendrier pour un logement
  def index
    calendriers = Calendrier.find_by(logement_id:params[:logement_id])
    promotion = Promotion.where(logement_id:params[:logement_id])
    delaimin = calendriers.delaimin
    nuitmin =calendriers.nuitmin
    ouvrir = calendriers.ouvrir
    tarif = calendriers.tarif


    debut = calendriers.startDate
    fin = calendriers.endDate
    
    dd=debut.day
    dm=debut.month
    dy=debut.year

    fd=fin.day
    fm=fin.month
    fy=fin.year
    #modifer la forme de la date de début
    starts = "#{dy}-#{dm}-#{dd}"
    #modifer la forme de la date de fin

    ends = "#{fy}-#{fm}-#{fd}"

    render json:{
      debut:starts,
      fin:ends,
      delaimin:delaimin,
      nuitmin:nuitmin,
      ouvrir:ouvrir,
      tarif:tarif,
      promotion:promotion
    }
  end

  #affichage des calendrier pour tous les logements avec le tarif
  def tout
    #propriétaire
    
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end

    user = current_user
    logements = Logement.where(user_id: user)
    tarif = []
    #================ propriétaire =====================
    logements.each do |logement|
      tarif << {logement:logement,tarif:logement.calendrier,photo:"#{logement.photos.first.photo}",promotion:logement.promotions}
    end
    
    #================= cogestion ============
    logcngestions = Logement.all
      logcngestions.each do |logcogestion|
        if logcogestion.user != user && logcogestion.cogestion.present?
          if logcogestion.cogestion.include?(user.id)
            tarif << {logement:logcogestion,tarif:logcogestion.calendrier,photo:"#{logcogestion.photos.first.photo}",promotion:logcogestion.promotions}
          end
        end
      end
    
    render json:{
      tarif:tarif
      }  
  end

  #recherche un caledrier  à partir du nom d'un legement
  def search
     # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end

  user = current_user
  logname = params[:recherche]
  logFilter = Logement.where(user_id: user).where("name ilike ? or idlogement ilike ? ","%#{logname}%","%#{logname}%")
  
  #resultat
  filtarif = []

      logFilter.each do |logement|
        filtarif << {logement:logement,tarif:logement.calendrier,photo:"#{logement.photos.first.photo}",promotion:logement.promotions}
      end
        logcngestions = Logement.all
        logements = []
        logcngestions.each do |logcogestion|
          if logcogestion.user != user && logcogestion.cogestion.present?
            if logcogestion.cogestion.include?(user.id)
              if logcogestion.name.downcase.include?(logname.downcase) || logcogestion.idlogement.downcase.include?(logname.downcase)
                filtarif << {logement:logcogestion,tarif:logcogestion.calendrier,photo:"#{logcogestion.photos.first.photo}",promotion:logcogestion.promotions}
              end
            end
          end
        end

      if filtarif.present?
          render json:{
            search:filtarif
            } 
      else
          render json:{
            search:nil
            } 
      end

  end
  #------------------------Fsearch------------------------------------------------------------
  #mis à jour d'un caledrier  
  def update
    logement = Logement.find(params[:logement_id])
    cal = Calendrier.find_by(logement_id:params[:logement_id])
  
      if current_user.has_attribute?(:admin)

        #==== params ===========
        statut = params[:ouvrir]
        delaimin = params[:delaimin]
        nuitmin = params[:nuitmin]
        tarif = params[:tarif]

        #=== Encien =====
        statut_e = logement.status
        delaimin_e = cal.delaimin
        nuitmin_e = cal.nuitmin
        tarif_e = cal.tarif

        #=== update ====
        if params[:ouvrir] == "yes"
          logement.update(status:true)
        else
          logement.update(status:false)
        end
        cal.update(startDate:params[:debut],endDate:params[:fin],delaimin:params[:delaimin],nuitmin:params[:nuitmin],ouvrir:params[:ouvrir],tarif:params[:tarif])

        if logement.status  !=  statut_e
          if params[:ouvrir] == "yes"
            Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification annonce – statut en ligne", admin_run_id: current_user.id)
          else
            Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification annonce – statut en pause", admin_run_id: current_user.id)
          end
        end
        if cal.delaimin  !=  delaimin_e
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification annonce – delai minimun", admin_run_id: current_user.id)
        end
        if cal.nuitmin  !=  nuitmin_e
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification annonce – nuit minimun", admin_run_id: current_user.id)
        end
        if cal.tarif  !=  tarif_e
          Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification annonce – tarif", admin_run_id: current_user.id)
        end
        
      else
        if params[:ouvrir] == "yes"
          logement.update(status:true)
        else
          logement.update(status:false)
        end
        cal.update(startDate:params[:debut],endDate:params[:fin],delaimin:params[:delaimin],nuitmin:params[:nuitmin],ouvrir:params[:ouvrir],tarif:params[:tarif])
      end
      

  end
end
