Rails.application.routes.draw do

  

  #information pour la réseravtion
  get '/logements/:logement_id/stripe/index',to:'stripe#index'
  post 'stripe/save_customer', to: "stripe#save_customer"
  #valide une réservation
  post 'stripe/charge_customer', to: "stripe#charge_customer"

  get 'stripe/create'
  get 'reponses/index'
  get 'commentaire/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resources :users, only:[:show,:create,:update,]
  #  resources :users, only: :create do 
  #   collection do
  #     get 'confirm'
  #   end
  # end
  get "/confirm", to: "users#confirm"
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  
  #============= home ===============
  get 'home/index'
  get '/logement/:logement_id/details/public',to:"home#show"
  get '/logement/:logement_id/photos/public',to:"home#photos"
  post 'recherchehome/index'
  get '/logement/ville/public',to:"home#ville"
  post '/destination/index',to:"destination#index"
  get '/logements/offre/details',to:"destination#tout_offre"
  #============ filter detail ============

  post 'recherchehome/filter'
  
  #============ commentaire ============
  post '/logements/:logement_id/commentaire/',to:"commentaire#create"
  get '/logement/:logement_id/commetaires/all',to:"commentaire#all"
  get '/logements/:logement_id/commentaire/pall',to:"commentaire#p_all"
  post '/commentaires/:commentaire_id/reponse',to:"commentaire#r_commentaire"
  #=============== invitaion =======
  
  post '/logements/:logement_id/invitation/',to:'users#invitaiton_send'
  post '/invitation/:user_id/:logement_id/:date',to:"users#invitation_accepte"
  #============= Cogestion ==================
  get '/cogestion/:logement_id/index',to:"cogestion#index"
  post '/cogestion/:logement_id/:id',to:"cogestion#delete"
  #==========================================  
  #=========== map =====================
  get '/logement/:logement_id/map/public',to:"home#map"
  get '/tout/caledriers',to:'calendriers#tout'
  post '/tout/caledriers',to:'calendriers#search'
  #==================================
  
  resources :logements do
    resources :chambres, only:[:index,:update,:create]
    resources :photos
    resources :bain_entiers, only:[:index]
    resources :reservations
    resources :conversations do #contact list
      resources :messages #message content
    end
    resources :conver_admin do
      resources :message_admin
    end
    resources :promotions
    resources :calendriers, only:[:index,:create]
  end

  #=========== message pas réponses proriétair =========
    get '/conversation/:logement_id/non_repondu',to:'conversations#non_repondu'

  #=================  extranet ==============================

  post '/reservations/:logement_id/:user_id', to: "reservations#annuler"
  get '/messages/:logement_id/msg_n' , to: "messages#count"
  post '/recherche/message/:logement_id/client',to:'recherche/rechemessage#index'
  delete '/chambre/delete/:id',to:"chambres#deletechambre"
  delete '/salon/delete/:id',to:"chambres#deletesalon"
  delete '/autre/delete/:id',to:"chambres#deleteautre"
  post '/prorietaire',to:"proritaire#index"
  post '/logements/:logement_id/recap' ,to:"reservations#filtre"
  put '/logements/:logement_id/nombrepersonne',to:"nombrepersonnes#update"
  put '/logements/:logement_id/calendriers', to:"calendriers#update"
  post'/logements/:logement_id/recherche/reservation',to: 'recherche/reservations#index'
  
  get '/message/:logement_id/nombre',to:'messages#number'
  
  put '/logements/:logement_id/equi_courants/',to:"equi_courants#update"
  get '/logements/:logement_id/equi_courants/',to:"equi_courants#index"
  
  put '/logements/:logement_id/cautions/',to:"cautions#update"
  get '/logements/:logement_id/cautions/',to:"cautions#index"
  
  get '/logements/:logement_id/frais_suples/',to:"frais_suples#index"
  post '/logements/:logement_id/frais_suples/',to:"frais_suples#create"
  delete '/frais_suples/:id',to:"frais_suples#delete"
  
  put '/logements/:logement_id/acces_voyageurs/',to:"acces_voyageurs#update"
  get '/logements/:logement_id/acces_voyageurs/',to:"acces_voyageurs#index"
  
  put '/logements/:logement_id/ressouce_voyageurs/',to:"ressouce_voyageurs#update"
  get '/logements/:logement_id/ressouce_voyageurs/',to:"ressouce_voyageurs#index"
  
  put '/logements/:logement_id/parms_reservations/',to:"parms_reservations#update"
  get '/logements/:logement_id/parms_reservations/',to:"parms_reservations#index"
  
  
  put '/logements/:logement_id/equi_familles/',to:"equi_familles#update"
  get '/logements/:logement_id/equi_familles/',to:"equi_familles#index"
  
  put '/logements/:logement_id/equi_logistiques/',to:"equi_logistiques#update"
  get '/logements/:logement_id/equi_logistiques/',to:"equi_logistiques#index"
  
  put '/logements/:logement_id/equi_securites/',to:"equi_securites#update"
  get '/logements/:logement_id/equi_securites/',to:"equi_securites#index"
  
  put '/logements/:logement_id/equi_suplementaires/',to:"equi_suplementaires#update"
  get '/logements/:logement_id/equi_suplementaires/',to:"equi_suplementaires#index"
  
  get '/logements/:logement_id/adresses',to:"adresses#show"
  put "/logements/:longement_id/adresse",to:"adresses#update"
  
  put "/avatar",to:"avatars#create"
  
  put '/logements/:longement_id/map',to:"maps#update"
  
  put '/logements/:longement_id/conditions',to:"conditions#upadte"
  get '/logements/:longement_id/conditions',to:"conditions#index"
  
  put '/logements/:longement_id/regles',to:"regles#upadte"
  get '/logements/:longement_id/regles',to:"regles#index"
  
  get '/proproietaire/reservation/tout',to:"reservations#all"
  post '/logements/reservation/recherche/dashboard',to:"recherche/reservations#all"
  

  
  # ===================  VOYAGEUR ========================
  get '/voyageur/reservation/cour',to:"reservations#in_court"
  get '/voyageur/:reservation_id/cour',to:"reservations#in_court_show"
  
  
  get '/voyageur/reservation/avenir',to:"reservations#to_come_up"
  get '/voyageur/:reservation_id/avenir',to:"reservations#to_come_up_show"
  
  get '/voyageur/reservation/terminer',to:"reservations#end"
  get '/voyageur/:reservation_id/terminer',to:"reservations#end_show"
  

  get 'conversation_clients/index'
  get '/conversation/:conversation_id/message',to:"message_clients#index"
  post '/logements/client/conversations/:conversation_id/messages',to:'messages#index'
  post '/recherche/message/client',to:'recherche/rechemessage#index_client'
  get '/recherche/messagenorepondu/client',to:'recherche/rechemessage#non_lit_client'
  get '/messages/client/non_lu',to:"message_clients#non_lu"
  get '/commentaires/client',to:'commentaire#list_comment'

  get '/logements/:logement_id/profil/user',to:"users#profil"
  get '/logements/:logement_id/reservation/commentaire',to:"commentaire#commentaire_reservation"
  post '/stripe/voygeur',to:'stripe#create'

  post '/forgot/password',to:"users#password"
  post '/new/password',to:"users#new_password"


  #========================== Admin +==============================================
  post '/login/admin',to:"admin/admin_run#login"
                #    USER   #
  get '/user/all',to:"admin/users#index"
  get '/user/:user_id/show',to:"admin/users#show"
  delete '/user/:user_id/delete',to:"admin/users#delete"
  
  get '/admin/logements/all',to:"admin/logements#index"
  get '/logement/:logement_id/show',to:"admin/logements#show"
  delete '/logements/:logement_id/delete',to:"admin/logements#delete"
                # message #
  get '/logement/:logement_id/conversation',to:"admin/conversation#index"
                  #create admin =====
  post '/create/admin',to:"admin/admin_run#create"
  get '/all/admin',to:"admin/admin_run#index"
  get '/show/:admin_id/admin',to:"admin/admin_run#show"
  post '/update/:admin_id/admin',to:"admin/admin_run#update"
  delete '/admin/:admin_id/delete',to:"admin/admin_run#delete"
  post '/admin/:admin_r/recherche',to:"admin/admin_run#recherche"


                  # recherche  #
  namespace :admin do
    post 'recherche/users'
    post 'recherche/logement'
    post 'recherche/reservation'
  end   
  #================ taxe ============
  get '/logement/:logement_id/taxes',to:'taxes#index'
  put '/logement/:logement_id/taxes',to:'taxes#update'
  #============ historique ==================
  get 'historique/index'
  get '/historique/:data/recherche',to:'historique#recherche'
  #============================ password ===========================================
      post '/admin/forgot/password',to:"admin/admin_run#password"
      post '/admin/new/password',to:"admin/admin_run#new_password"
  #============================ compta ===========================================
  get '/compta/:logement_id/facture',to:"compta#facture"
  get '/compta/:logement_id/facture/:year',to:"compta#facture"
  post '/compta/:logement_id/facture/:recherche',to:"compta#recherche"

  get '/compta/:logement_id/cordonne_facture',to:"compta#cordonne_facture"
  post '/compta/:logement_id/cordonne_facture_update',to:"compta#cordonne_facture_update"
  get 'compta/cordonne_bancaire'
  get '/compta/index/all',to:"admin/compta#index"
  get '/compta/:filtre/filtre',to:"admin/compta#filtre"
  get '/compta/:recherche/recherche',to:"admin/compta#recherche"
  #===================== coordonnée bancaire ===================================
  get '/compta/:logement_id/cordonne_bancaire',to:'compta#cordonne_bancaire'
  get '/compta/:logement_id/send_code',to:'compta#send_code'
  get '/compta/:logement_id/cofirm_code/:code',to:'compta#cofirm_code'
  put '/compta/:logement_id/update_cordonne_bancaire',to:'compta#update_cordonne_bancaire'
  
  #===============================================================================
end
