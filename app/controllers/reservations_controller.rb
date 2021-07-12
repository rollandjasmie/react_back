class ReservationsController < ApplicationController
      before_action :authorized, only: [:all, :annuler, :create, :update, :in_court, :to_come_up, :end]


  # GET /reservations
  def all
      # Block execution if there is no current user
      if(current_user.blank?)
        return render json:{
          errors: "true",
          message: "User not connected"
        }, status: 401
      end

      user = current_user
      logements = Logement.where(user_id:user.id)
      reservations = []
      encour = []
      avenir = []
      annuler = []
      terminer = []
      logements.each do |logement|
        logement.reservations.each do |reservation|
          reservations << {logement:logement,reservation:reservation,user:reservation.user}
        end
      end
      logcngestions = Logement.all
      logcngestions.each do |logcogestion|
        if logcogestion.user != user && logcogestion.cogestion.present?
          if logcogestion.cogestion.include?(user.id)
            #========== tout================
            logcogestion.reservations.each do |reservation|
              reservations << {logement:logcogestion,reservation:reservation,user:reservation.user}
            end
          end
          #=============== en cour =========
          if logcogestion.cogestion.include?(user.id)
            res = logcogestion.reservations.where("depart >= ?", Date.today).where("arrivee <= ?",Date.today).where(status: "accepter")
            res.each do |reservation|
              encour<< {logement:logcogestion,reservation:reservation,user:reservation.user}
            end
          end
          #================ avenir =================
          if logcogestion.cogestion.include?(user.id)
            res = logcogestion.reservations.where("arrivee > ?",Date.today).where(status: "accepter")
            res.each do |reservation|
              avenir<< {logement:logcogestion,reservation:reservation,user:reservation.user}
            end
          end
          #================ les reservation anuuler =================
          if logcogestion.cogestion.include?(user.id)
            res = logcogestion.reservations.where(status: "annuler")
            res.each do |reservation|
              annuler << {logement:logcogestion,reservation:reservation,user:reservation.user}
            end
          end
          #================ les reservation terminer =================
          if logcogestion.cogestion.include?(user.id)
            res = logcogestion.reservations.where("depart < ?", Date.today).where(status: "accepter")
             res.each do |reservation|
              terminer << {logement:logcogestion,reservation:reservation,user:reservation.user}
            end
          end
        end
      end
      
      #les reservation en cour-----------------
      
      logements.each do |logement|
        res = logement.reservations.where("depart >= ?", Date.today).where("arrivee <= ?",Date.today).where(status: "accepter")
        res.each do |reservation|
          encour<< {logement:logement,reservation:reservation,user:reservation.user}
        end
      end
      #----------------------------------------
      #les reservation avernir-----------------
      
      logements.each do |logement|
        res = logement.reservations.where("arrivee > ?",Date.today).where(status: "accepter")
        res.each do |reservation|
          avenir<< {logement:logement,reservation:reservation,user:reservation.user}
        end
      end
      #----------------------------------------
      #les reservation anuuler-----------------
      
      logements.each do |logement|
        res = logement.reservations.where(status: "annuler")
        res.each do |reservation|
          annuler << {logement:logement,reservation:reservation,user:reservation.user}
        end
      end
      #----------------------------------------
      #les reservation terminer-----------------
      
      logements.each do |logement|
        res = logement.reservations.where("depart < ?", Date.today).where(status: "accepter")
        res.each do |reservation|
          terminer << {logement:logement,reservation:reservation,user:reservation.user}
        end
      end
      #----------------------------------------

      if reservations.present?
        render json:{
          reservations:reservations,
          encour: encour,
          avenir: avenir,
          annuler: annuler,
          terminer: terminer
        }
      end
  end
  
  def index
    reservations =Reservation.where(logement_id:params[:logement_id])
    users = []
    if reservations.present?
      reservations.each do |user|
        users << user.user
      end    
      render json:{
        reservation:reservations, 
        user:users
      }
    end
  end


  def annuler #demande annulation du reservation
     conversation = Conversation.where(user_id:params[:user_id],logement_id:params[:logement_id])
    
    if conversation.empty?
      conversation = Conversation.create(user_id:params[:user_id],logement_id:params[:logement_id])     
     conversation.messages.new(content: "Desoler de vous informer le logement que vous avez reserver est deja prise donc votre reservation va etre annuler", is_client:params[:logement_id]).save

    else
      conversation = Conversation.find_by(user_id:params[:user_id],logement_id:params[:logement_id])

      conversation.messages.create(content: "Desoler de vous informer le logement que vous avez reserver est deja prise donc votre reservation va etre annuler", is_client:params[:logement_id])
    end
      render json:{
        conversation:conversation
      }
  end


  def filtre
    now = params[:now].to_i
    arriver = []
    depart = []
    actives = [] 
    date = Date.today
    months_next = date + 30
    date_next = date + 6
    date_prev = date - 6
    date_prev_15 = date - 15
    next_months = (months_next..months_next+30).to_a
    next_week = (date_next..date_next+6).to_a
    prev_week = (date_prev-6..date_prev).to_a
    prev_day = (date_prev_15..date).to_a
    date_now = date
    active_now = []
    interval = nil
    depart_interval = nil
    arriver_interval = nil
    totaux_day = []
    demande = []
     Reservation.where({logement_id:params[:logement_id], status: "accepter"}).each do |reservation|
       if date_prev_15 <=reservation.arrivee && date-1 >= reservation.depart 
        actives << reservation
       end
    end
 
    #si filtre aujourd'hui
    if now == 0
    arriver_now = Reservation.where({logement_id:params[:logement_id],arrivee: date, status: "accepter"}).count
    depart_now =  Reservation.where({logement_id:params[:logement_id],depart: date, status: "accepter"}).count
    arriver << arriver_now
    depart << depart_now
   #Sejour en cour -----------------------
    Reservation.where({logement_id:params[:logement_id], status: "accepter"}).each do |reservation|
        depart_interval = reservation.depart
        arriver_interval = reservation.arrivee
        interval = (arriver_interval..depart_interval).to_a   
          if interval.include?(date)
            totaux_day << reservation
          end
      end
    #----------------------------------------

    #Demande client---------------------------
     Reservation.where({logement_id:params[:logement_id], status: "En attente"}).each do |reservation|
        depart_interval = reservation.depart
        arriver_interval = reservation.arrivee
        interval = (arriver_interval..depart_interval).to_a 
          if interval.include?(date_now)
            demande << reservation
          end
      end
    #----------------------------------------

    #si filtre semaine prochaine
    elsif now == 1
    next_week.map{|dates|
    arriver_now = Reservation.where({logement_id:params[:logement_id],arrivee: dates.to_s , status: "accepter"}).count
    depart_now =  Reservation.where({logement_id:params[:logement_id],depart: dates.to_s, status: "accepter"}).count
    # Reservation.where({logement_id:params[:logement_id],depart: date.to_s})
    arriver << arriver_now
    depart << depart_now
    }
   #Sejour en cour -----------------------
    Reservation.where({logement_id:params[:logement_id], status: "accepter"}).each do |reservation|
        depart_interval = reservation.depart
        arriver_interval = reservation.arrivee
        interval = (arriver_interval..depart_interval).to_a
        next_week.map{|dates|
          if interval.include?(dates)
            totaux_day << reservation
            break
          end
        }
      end
    #----------------------------------------
    #Demande client---------------------------
      Reservation.where({logement_id:params[:logement_id], status: "En attente"}).each do |reservation|
        depart_interval = reservation.depart
        arriver_interval = reservation.arrivee
        interval = (arriver_interval..depart_interval).to_a
        next_week.map{|dates|
          if interval.include?(dates)
            demande << reservation
            break
          end
        }
      end
    #----------------------------------------
    #si filtre moi prochaine
    elsif now == 2

    next_months.map{|dates|
    arriver_now = Reservation.where({logement_id:params[:logement_id],arrivee: dates.to_s, status: "accepter"}).count
    depart_now =  Reservation.where({logement_id:params[:logement_id],depart: dates.to_s, status: "accepter"}).count
    # Reservation.where({logement_id:params[:logement_id],depart: date.to_s})
    arriver << arriver_now
    depart << depart_now
    }
   
     #Sejour en cour -----------------------
      Reservation.where({logement_id:params[:logement_id], status: "accepter"}).each do |reservation|
        depart_interval = reservation.depart - 1
        arriver_interval = reservation.arrivee
        interval = (arriver_interval..depart_interval).to_a
        next_months.map{|dates|
          if interval.include?(dates)
            totaux_day << reservation
            break
          end
        }
      end

    #----------------------------------------
    #Demande client---------------------------
      Reservation.where({logement_id:params[:logement_id], status: "En attente"}).each do |reservation|
        depart_interval = reservation.depart - 1
        arriver_interval = reservation.arrivee
        interval = (arriver_interval..depart_interval).to_a
        next_months.map{|dates|
          if interval.include?(dates)
            demande << reservation
            break
          end
        }
    end
    #----------------------------------------

    elsif now == -1 

       prev_week.map{|dates|
      arriver_now = Reservation.where({logement_id:params[:logement_id],arrivee: dates.to_s, status: "accepter"}).count
      depart_now =  Reservation.where({logement_id:params[:logement_id],depart: dates.to_s, status: "accepter"}).count
      arriver << arriver_now
      depart << depart_now
      }
      #Sejour en cour -----------------------
          Reservation.where({logement_id:params[:logement_id], status: "accepter"}).each do |reservation|
        depart_interval = reservation.depart
        arriver_interval = reservation.arrivee
        interval = (arriver_interval..depart_interval).to_a
        prev_week.map{|dates|
          if interval.include?(dates)
            totaux_day << reservation
            break
          end
        }
      end
      #----------------------------------------
      #Demande client---------------------------
          Reservation.where({logement_id:params[:logement_id], status: "En attente"}).each do |reservation|
          depart_interval = reservation.depart
          arriver_interval = reservation.arrivee
          interval = (arriver_interval..depart_interval).to_a
          prev_week.map{|dates|
            if interval.include?(dates)
              demande << reservation
              break
            end
          }
        end
      #----------------------------------------

      end
      total_arriver = arriver.sum
      total_depart = depart.sum
      total_active = actives.count
      demande_total = demande.count
      render json:{
      total_arriver:total_arriver,
      total_depart:total_depart,
      total_active:total_active ,
      totaux_day: totaux_day.count,
      demande_total: demande_total
    }
  end
  # GET /reservations/1
  def show
    logement = Logement.find(params[:logement_id])
    
    # caution = Caution.find_by(logement_id:logement.id)
    frais_suples = FraisSuple.where(logement_id:logement.id)
    taxe = TaxeDeSejour.find_by(logement_id:logement.id)
    frais_supl =[]

    frais_suples.each do |frais|
      frais_supl <<  frais
    end
        
    reservation =Reservation.find(params[:id])
    user = User.find(reservation.user_id)

    if frais_supl.present?
      render json:{
          reservation:reservation,
          user:user,
          # caution:caution,
          taxe:taxe,
          frais_suple:frais_supl
        }
    else
      render json:{
          reservation:reservation,
          user:user,
          taxe:taxe,
          # caution:caution,
          frais_suple:nil
        }
    end   
  end

  # POST /reservations
  def create
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    
    reservation = Reservation.new(arrivee:params[:arrivee],depart:params[:depart],status:"En attente",nombre_personne:params[:nombre_personne],numero_credit:params[:numero_credit],idreservation:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}")
    tarif = Calendrier.find_by(logement_id:params[:logement_id]).tarif
    taxe=TaxeDeSejour.find_by(logement_id:params[:logement_id]).taxe
    
    dure = (Date.parse(params[:arrivee])..Date.parse(params[:depart])).count 
    reservation.duree =dure
    # caution = Caution.find_by(logement_id:params[:logement_id]).montant.to_i
    
    frais = FraisSuple.where(logement_id:params[:logement_id])
    
    fraiss=0
    if frais.present?
      frais.each do |fra|
        if fra.facturation == "/Nuit"
          fraiss += (fra.montant.to_i*dure)
        end
        if fra.facturation == "/séjour"
          fraiss += fra.montant.to_i
        end
        
        
      end
    end
    commission =nil
    if fraiss == 0
      com1 = ((dure*tarif)*3)/100
      com2 = ((dure*tarif)*10)/100
      commission=com1+com2
      reservation.commition_et_frais=(commission + taxe)
    else
      com1 = (((dure*tarif)+fraiss)*3)/100
      com2 = (((dure*tarif)+fraiss)*10)/100
      commission=com1+com2
      reservation.commition_et_frais=(commission+fraiss + taxe)
    end
    montantT = nil
    if fraiss == 0
      montantT = (dure*tarif)+(((dure*tarif)*3)/100) + taxe
    else
      montantT = (dure*tarif) + fraiss + (((( (dure*tarif) + fraiss)*3)/100)) + taxe
    end

    reservation.commission=commission
    reservation.montan_total = montantT
    reservation.tarif = tarif
    reservation.user_id = current_user.id
    reservation.logement_id = params[:logement_id]
    
    # tax = Commissiontax.find_by(logement_id:params[:logement_id]).tax
    if reservation.save
      montantnet = nil
      if fraiss == 0
        montantnet = montantT - (((dure*tarif)*3)/100) - (((dure*tarif)*10)/100) - taxe
      else
        montantnet = montantT - (((( (dure*tarif) + fraiss)*3)/100)) - (((( (dure*tarif) + fraiss)*10)/100)) - taxe
      end
      sejour = "#{Date.parse(params[:arrivee]).day}/#{Date.parse(params[:arrivee]).month}-#{Date.parse(params[:depart]).day}/#{Date.parse(params[:depart]).month}"
      proprio = Logement.find(params[:logement_id]).user
      FactureVersement.create(numreservation: reservation.idreservation, voyageur: "#{current_user.first_name}#{" "}#{current_user.first_name}", montantnet:montantnet, datedevirment: nil, sejour: sejour, tariftotal: montantT, commission: commission, taxe: taxe, logement_id: params[:logement_id], user_id: current_user.id,idProrio:proprio.iduser,nomProprio:"#{proprio.first_name}#{" "}#{proprio.name}",sanstaxe:montantT-taxe,statut:"En attente") 
    
    end
    
    render json:{reservation:reservation}    
    
  end

  # PATCH/PUT /reservations/1
  def update
    reservation = Reservation.where(id:params[:id])
    

    if current_user.has_attribute?(:admin)
       if params[:arrivee]
        reservation.update(arrivee:params[:arrivee])
        Historique.create(pseudoadmin: current_user.pseudo, prorietaire: reservation.idreservation, action: "Modification réservation – date de séjour", admin_run_id: current_user.id)
        end
      if params[:depart]
        reservation.update(depart:params[:depart])
        Historique.create(pseudoadmin: current_user.pseudo, prorietaire: reservation.idreservation, action: "Modification réservation – date de séjour", admin_run_id: current_user.id)
      end
    else
      if params[:arrivee]
        reservation.update(arrivee:params[:arrivee])
      end
      if params[:depart]
        reservation.update(depart:params[:depart])
      end
    end
  end
  def  in_court
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    reservations = Reservation.where(user_id:current_user.id)
    in_court = []
    hebergement = []

    reservations.each do |reservation|
      if (reservation.arrivee..reservation.depart).include?(Date.today)        
        in_court << reservation
        hebergement << reservation.logement

      end
    end
    if in_court.present?
      render json:{
          reservation:in_court,
          hebergement:hebergement

        } 
    end
    
  end
  def to_come_up
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    reservations = Reservation.where(user_id:current_user.id)

    to_come_up = []
    hebergement = []
    
    reservations.each do |reservation|
      if reservation.arrivee > Date.today
        to_come_up << reservation
        hebergement << reservation.logement

      end
    end
    if to_come_up.present?
      render json:{
          reservation:to_come_up,
          hebergement:hebergement
      }
    end
  end
  def to_come_up_show
    reservation = Reservation.find(params[:reservation_id].to_i)
    logement = reservation.logement.photos.first
    logement = logement.photo
    render json:{
      reservation:reservation,
      photo:logement
    }
  end
  def in_court_show
     reservation = Reservation.find(params[:reservation_id].to_i)
    logement = reservation.logement.photos.first
    logement = logement.photo
    render json:{
      reservation:reservation,
      photo:logement
    }
  end
  
  def end
    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end
    reservations = Reservation.where(user_id:current_user.id)
    fin = []
    hebergement = []

    reservations.each do |reservation|
      if reservation.depart < Date.today
        fin << reservation
        hebergement << reservation.logement

      end
    end
  def end_show
     reservation = Reservation.find(params[:reservation_id].to_i)
    logement = reservation.logement.photos.first
    logement = logement.photo
    render json:{
      reservation:reservation,
      photo:logement
    }
  end
    if fin.present?
      render json:{
        reservation:fin,
        hebergement:hebergement

    }
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def reservation_params
      params.require(:reservation).permit(:arrivee, :depart, :status, :commission, :duree, :montan_total, :commition_et_frais, :tarif)
    end
end
