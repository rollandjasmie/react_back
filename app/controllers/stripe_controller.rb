class StripeController < ApplicationController
    before_action :authorized, only: [:auto_login]
  #information pour créer une réservation
  def index
    tarif = Calendrier.find_by(logement_id:params[:logement_id]).tarif
    taxe=TaxeDeSejour.find_by(logement_id:params[:logement_id]).taxe
    frais = FraisSuple.where(logement_id:params[:logement_id])
        
        fraiss=[]
        if frais.present?
          frais.each do |fra|
              fraiss << fra
          end
        end
        
        if fraiss.present?
          render json: {
            prix_de_la_nuit:tarif,
            taxe_de_sejour:taxe,
            frais_annexes:frais
          }
        else
            render json: {
            prix_de_la_nuit:tarif,
            taxe_de_sejour:taxe,
            frais_annexes:nil
          }
        end
        
  end
  
  # \save_customer params: pm_token(payment method token)
  def save_customer 
    if  params[:token] && params[:arrivee] && params[:depart] && params[:nombre_personne]
           # \save_customer params: pm_token(payment method token)
          Stripe.api_key = ENV["CLE_STRIPE_PAYMENT"]

          idreservation = "#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}"
          email = current_user.email
          # email = params[:client_email]
          payment_token = params[:token][:id]

          # Create stripe customer
          customer = Stripe::Customer.create({
            email: email,
            source: payment_token
          })

          # save stripe customer into database
       
          stripe_customer = StripeCustomer.new(
            customer_id: customer[:id], 
            payment_method_id: params[:token][:card][:id], 
            user_email: email,
            idreservation:idreservation
          )
        reservation = Reservation.new(arrivee:params[:arrivee],depart:params[:depart],status:"En attente",nombre_personne:params[:nombre_personne].to_i,numero_credit:nil,idreservation:idreservation)
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
          commission = ((dure*tarif)*3)/100
          reservation.commition_et_frais=(commission + taxe)
        else
          commission = (((dure*tarif)+fraiss)*3)/100
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
        if reservation.save  &&  stripe_customer.save
         
          montantnet = nil
          if fraiss == 0
            montantnet = montantT - (((dure*tarif)*3)/100) - (((dure*tarif)*10)/100) - taxe
            
          else
            montantnet = montantT - (((( (dure*tarif) + fraiss)*3)/100)) - (((( (dure*tarif) + fraiss)*10)/100)) - taxe
          end
          sejour = "#{Date.parse(params[:arrivee]).day}/#{Date.parse(params[:arrivee]).month}-#{Date.parse(params[:depart]).day}/#{Date.parse(params[:depart]).month}"
          proprio = Logement.find(params[:logement_id]).user
          FactureVersement.create(numreservation: reservation.idreservation, voyageur: "#{current_user.first_name}#{" "}#{current_user.first_name}", montantnet:montantnet, datedevirment: nil, sejour: sejour, tariftotal: montantT, commission: ((montantT - taxe)*12.63)/100, taxe: taxe, logement_id: params[:logement_id], user_id: current_user.id,idProrio:proprio.iduser,nomProprio:"#{proprio.first_name}#{" "}#{proprio.name}",sanstaxe:montantT-taxe,statut:"En attente") 
          
          render json: {error: "false", message: "registered with success"}
        else
          return render json: {error: "true", message: "An error occured"}
        end
    end
  end

  # \charge_customer
  # params: idreservation
  def charge_customer
    if params[:status] == "accepter"
      Stripe.api_key = ENV["CLE_STRIPE_PAYMENT"]
      customer = StripeCustomer.find_by(idreservation: params[:idreservation])
      facture_versement = FactureVersement.find_by(numreservation: params[:idreservation])
      reservation = Reservation.find_by(idreservation: params[:idreservation])
      logement_id = Logement.find_by(id:reservation.logement_id).idlogement
      voyageur_id = User.find_by(id:reservation.user_id).iduser

      if customer.blank?
        return render json:{
          error: "true",
          message: "User not registered inside stripe_customers"
          }, status: 404
      end

      begin
        amount = (facture_versement.tariftotal*100).to_i
        intent = Stripe::PaymentIntent.create({
          amount: amount,
          currency: 'eur',
          customer: customer.customer_id,
          payment_method: customer.payment_method_id,
          error_on_requires_action: true,
          description:"id_réservation :#{reservation.idreservation},
          id_logement :#{logement_id  },
          id_proprietaire :#{facture_versement.idProrio},
          id_voaygeur: #{voyageur_id}",
          confirm: true,
        })
        reservation.update(status:"accepter")
        render json: intent
      rescue Stripe::CardError => e
        # Error code will be authentication_required if authentication is needed
        puts "Error is: #{e.error.code}"
        payment_intent_id = e.error.payment_intent.id
        payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
        puts payment_intent.id

        render json: { error: "Error is: #{e.error.code}", payment_intent_id: e.error.payment_intent.id }
      end
    elsif params[:status] == "annuler"
      reservation = Reservation.find_by(idreservation: params[:idreservation])
      reservation.update(status:"annuler",commission:0)
      FactureVersement.find_by(numreservation: reservation.idreservation).destroy
    end
  end
end




