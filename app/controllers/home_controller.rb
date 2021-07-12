class HomeController < ApplicationController
  before_action :authorized, only: [:auto_login]

  def index
    logements = []
     i = 0
       Logement.all.each do |logement|
        i +=1
            if logement.status == true
              
              if logement.promotions.present? && logement.promotions.last.datevuedebut <= Date.today && Date.today <= logement.promotions.last.datevuefin
                logements << {logement: logement,photo:"#{logement.photos.first.photo.url}", calendrier: logement.calendrier,ville:logement.adresse.ville,promotion:logement.promotions.last}  
              # else
              #   if Rails.env == "production"
              #     logements << {logement: logement,photo:"http://f07f4cb.online-server.cloud#{logement.photos.first.photo.url}", calendrier: logement.calendrier,ville:logement.adresse.ville}
              #   else
              #     logements << {logement: logement,photo:"http://localhost:4000#{logement.photos.first.photo.url}", calendrier: logement.calendrier,ville:logement.adresse.ville}
              #   end
              end
              
        end  
        break if i == 9
      end
      render json: {logement: logements.uniq}
  end
  def map # affiche du map pour un logement  
    logement = Logement.find(params[:logement_id])
    reservations = logement.reservations
    contact = []
    reservations.each do |reservation|
      contact << reservation.user_id
    end
    maps = logement.map
    if contact.present?
      render json: {log:maps.longitude,lat:maps.latitude,zoom:maps.zoom,contact:contact}
    else
      render json: {log:maps.longitude,lat:maps.latitude,zoom:maps.zoom,contact:nil}
    end
  end
  
  def show#affichage d'un logement sur une page special et tous les objets qui lieé à ce logement
    logement = Logement.find(params[:logement_id])
    ville = logement.adresse.ville
   #3 photos d'un logement
    photos = []
    i = 0
    logement.photos.each do |photo|
        i +=1
        photos << "#{photo.photo.url}"
        break if i == 3
    end

    calendrier = logement.calendrier

    condition = logement.condition.conditions
    
    nombrepersonne = logement.nombrepersonne.number
    

    #tous les équipements d'un logement
    equipement = []
    
    courant = logement.equi_courant
    if courant
      courant.title.each do |name|
        equipement << name
      end
    end
    
    famille = logement.equi_famille
    if famille
        famille.title.each do |name|
          equipement << name
        end 
    end
    
    suple = logement.equi_suplementaire
    if suple
      suple.title.each do |name|
        equipement << name
      end
    end
    
    logist = logement.equi_logistique
    if logist
      logist.title.each do |name|
        equipement << name
      end
    end
    
    equipements = equipement.uniq
    #réglement interieru
    regleints = logement.parms_reservation.title
    #condition d'annulation
    regles = logement.regle
    #tous es chambres lieé à cet logement
    chambres = []
    chambre = logement.chambres
    lits = []
    # chambre.each do |chm|
    #   chambres << {chambre:chm.title,lits:chm.lits.where.not(checked:false)}
    # end
    chambre.each do |chm|
      chm.lits.each do |lit|
        if lit.checked== true
          lits << lit
        end
        
      end
    end

    # salons = []
    salon = logement.salons
    #  salon.each do |chm|
    #     salons << {salon:chm.title,canapes:chm.canapes.where.not(checked:false)}
    #  end

    # autres = []
    autre = logement.autres
    # autre.each do |chm|
      # autres << {autre:chm.title,autreslits:chm.autrelits.where.not(checked:false)}
    # end  
  if salon.present? && autre.present?
    logements ={
      logement:logement,
      ville:ville,
      photo:photos,
      calendrier:calendrier,
      condition:condition,
      nombrepersonne:nombrepersonne,
      chambres:chambre,
      equipements:equipements,
      regleints:regleints,
      regles:regles,
      lits:lits,
      salon:salon,
      autres:autre,
      }
      render json:{logement:logements} 
    elsif salon.present?
      logements ={
      logement:logement,
      ville:ville,
      photo:photos,
      calendrier:calendrier,
      condition:condition,
      nombrepersonne:nombrepersonne,
      chambres:chambre,
      regleints:regleints,
      regles:regles,
      equipements:equipements,
      lits:lits,
      salon:salon,}
      
      render json:{logement:logements}
    elsif autre.present?
      logements ={
      logement:logement,
      ville:ville,
      photo:photos,
      calendrier:calendrier,
      condition:condition,
      nombrepersonne:nombrepersonne,
      equipements:equipements,
      chambres:chambre,
      regleints:regleints,
      regles:regles,
      lits:lits,
      autres:autre,
    }
      render json:{logement:logements} 
    else
   logements ={
      logement:logement,
      ville:ville,
      photo:photos,
      calendrier:calendrier,
      condition:condition,
      nombrepersonne:nombrepersonne,
      equipements:equipements,
      chambres:chambre,
      regleints:regleints,
      regles:regles,

      }
        render json:{logement:logements} 
    end
    
  end
  def photos#totes les photos d-un logement affiché dans un page spécial
    logement = Logement.find(params[:logement_id])
    photos = logement.photos
    images = []

    photos.each do |photo|
      images << {photo:"#{photo.photo.url}",subcaption:photo.legend}
    end
    
    render json:{
      photos:images
    }
  end

  def ville#tous les logements claseé par ville (seulement 6)
  villes=["Basse Vallée","Bernica","Bois de Nèfles","Bras Panon","Cambuston","Cilaos","Entre Deux","Gillot","Grand Îlet","Hell Bourg","L'Étang-Salé","La Bretagne","La Chaloupe","La Montagne","La Nouvelle","La Plaine des Cafres","La Plaine des Palmistes","La Possession","La Rivière","La Saline","La Saline les Bains","Le Guillaume","Le Port","Le Quatorzième","Le Tampon","Le Tévelave","Les Avirons","Les Makes","Les Trois Bassins","Les Trois Mares","Manapany les Bains","Palmiste Rouge","Petite-Île","Rivière des Pluies","Rivière du Mat","Saint-André","Saint-Benoît","Saint-Bernard","Saint-Denis","Saint-Gilles les Bains","Saint-Gilles les Hauts","Saint-Joseph","Saint-Leu","Saint-Louis","Saint-Paul","Saint-Philippe","Saint-Pierre"]
  ville={0=>[],
1=>[],
2=>[],
3=>[],
4=>[],
5=>[],
6=>[],
7=>[],
8=>[],
9=>[],
10=>[],
11=>[],
12=>[],
13=>[],
14=>[],
15=>[],
16=>[],
17=>[],
18=>[],
19=>[],
20=>[],
21=>[],
22=>[],
23=>[],
24=>[],
25=>[],
26=>[],
27=>[],
28=>[],
29=>[],
30=>[],
31=>[],
32=>[],
33=>[],
34=>[],
35=>[],
36=>[],
37=>[],
38=>[],
39=>[],
40=>[],
41=>[],
42=>[],
43=>[],
44=>[],
45=>[],
46=>[],
47=>[],
48=>[]}

  logements = Logement.all
  a = 0
    villes.each do |vil|
      logements.each do |logs|
        if logs.adresse.ville == vil && logs.status == true
          ville[a]<<{logement: logs,photo:"#{logs.photos.first.photo.url}", calendrier: logs.calendrier,ville:logs.adresse.ville}
        end
      end
      a += 1
    end
    tout = []
    ville.each do |k,v|
      if v.present?
        tout << v
      end
    end
  render json:{
      photos:tout
    }
  end
  
  
end

