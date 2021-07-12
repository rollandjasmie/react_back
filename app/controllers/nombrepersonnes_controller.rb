class NombrepersonnesController < ApplicationController
  before_action :authorized
  
  def update#nombre de personnes maximum pour cet logement
    nombre = Nombrepersonne.find_by(logement_id:params[:logement_id])
    if current_user.has_attribute?(:admin)#pour l'admin
      logement = Logement.find(params[:logement_id])
      if params[:personne]
        nombre.update(number:params[:personne].to_i)
        Historique.create(pseudoadmin: current_user.pseudo, prorietaire: logement.idlogement, action: "Modification logement - Nombre de pérsonnes", admin_run_id: current_user.id)
      end
    else#pour propriétaire
      if params[:personne]
        nombre.update(number:params[:personne].to_i)
      end
    end
  end
end
