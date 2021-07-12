class CommentaireController < ApplicationController
  before_action :authorized, only: [:create, :destroy]
  
  #liste de toutes les commentaires pour un logement(sur extranet) ==================
  def p_all
    logement = Logement.find(params[:logement_id])
    commentaire = logement.commentaires

    tout_notes = commentaire.count * 40
    tout_note = 0

    tout_count = commentaire.count
    personnel=0
    qualite_prix=0
    proprete=0
    equipement=0

    commentaires = []
    commentaire.each do |c|
      notes = c.personnel + c.qualite_prix + c.proprete + c.equipement
      
      tout_note +=notes
      note = ((notes*10)/40).round(1) 
      
      personnel +=c.personnel
      qualite_prix +=c.qualite_prix
      proprete +=c.proprete
      equipement +=c.equipement

      if c.reponses.present?
        commentaires << {commentaire:c,user:c.user.email,note:note,reponses:c.reponses}
      else
        commentaires << {commentaire:c,user:c.user.email,note:note,reponses:nil}
      end
      
    end
    if tout_note !=0
      note_general =  (tout_note*10)/tout_notes
      render json: {commentaires:commentaires,general:{note_general:(note_general).round(1),personnel:(personnel/tout_count).round(1),qualite_prix:(qualite_prix/tout_count).round(1),proprete:(proprete/tout_count).round(1),equipement:(equipement/tout_count).round(1)}}      
    end
    
  end
  def r_commentaire
    commentaire = Commentaire.find(params[:commentaire_id])
    reponse = Reponse.create(content:params[:content],commentaire_id:commentaire.id,is_client:current_user.id,name:"#{current_user.name} #{current_user.first_name}")
    render json: {response:reponse}
  end


  #toutes les commentaires que le voyager a fait 
	def all
    logement = Logement.find(params[:logement_id])
    commentairess = logement.commentaires
    commentaires =[]
    commentairess.each do |commentaire|
      
      if commentaire.reponses.present?
        commentaires << {commentaires:commentaire,reponse:commentaire.reponses}
      else
        commentaires << {commentaires:commentaire,user:logement}
      end
      
    end
    if commentaires
      render  json: {comment:commentaires}
    end
    
  end
  
  #creation d'une commentaire
	def create

    # Block execution if there is no current user
    if(current_user.blank?)
      return render json:{
        errors: "true",
        message: "User not connected"
      }, status: 401
    end

    comments = Commentaire.create(content: params[:content],
    user_id: current_user.id,
    logement_id: params[:logement_id],
    name: current_user.name,
    note:params[:note],personnel:params[:personnel],
    qualite_prix:params[:qualite_prix],
    proprete:params[:proprete],
    equipement:params[:equipement])

    render json: {comment:comments}
  end
  #liste de toutes les commentaires pour un logement(sur home page) ==================

  def list_comment
    user = current_user
    commentaires =Commentaire.all
    comments = []
    commentaires.each do |commentaire|
      if commentaire.user_id == user.id
        {commentaire:commentaire,logement:commentaire.logement,photo_logement:"#{commentaire.logement.photos.first.photo.url}",reponses:commentaire.reponses}
      end
    end
    render json: {commentaire:comments}
  end
  

	def show
		comment = Commentaire.find(params[:id])
		responses = comment.responses
  end
  #afficher un contact si un réservation est déjà accepté
  def commentaire_reservation
    logement = Logement.find(params[:logement_id])
    reservations = logement.reservations
    commentaire = []
    contact = []
    reservations.each do |reservation|
      if reservation.status == "accepter" && reservation.arrivee < Time.now
        commentaire << reservation.user_id
      end
      contact << reservation.user_id
    end
    render json: {reservation:commentaire,contact:contact} 
  end
  
#effacer un commnetaire 
	def destroy
		comments = Commentaire.find(params[:id])
    comments.destroy
	end
end
