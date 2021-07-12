    # # This file should contain all the record creation needed to seed the database with its default values.
    # # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
    # #
    # # Examples:
    # #
    # #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
    # #   Character.create(name: 'Luke', movie: movies.first)
    User.destroy_all
    Logement.destroy_all
    Chambre.destroy_all
    BainEntier.destroy_all
    BainDemi.destroy_all
    Cuisine.destroy_all
    Kitchenette.destroy_all
    Adresse.destroy_all
    Map.destroy_all
    Nombrepersonne.destroy_all
    Salon.destroy_all
    Canape.destroy_all
    Canape.destroy_all
    Autre.destroy_all
    Autrelit.destroy_all
    Autrelit.destroy_all
    Autrelit.destroy_all
    ParmsReservation.destroy_all
    Regle.destroy_all
    Calendrier.destroy_all
    Condition.destroy_all
    Lit.destroy_all
    EquiFamille.destroy_all
    EquiLogistique.destroy_all
    EquiSecurite.destroy_all
    EquiSuplementaire.destroy_all
    AccesVoyageur.destroy_all
    RessouceVoyageur.destroy_all
    Caution.destroy_all
    FraisSuple.destroy_all
    FraisSuple.destroy_all
    Commissiontax.destroy_all
    Reservation.destroy_all
    Conversation.destroy_all
    ConverAdmin.destroy_all
    Photo.destroy_all
    Message.destroy_all
    AdminRun.destroy_all
    FactureVersement.destroy_all

    user0 = User.create(name:'Run',first_name:'bnb',sexe:'homme',date_of_birth:'12/09/92',adresse:'Tana',mobile:"+261390987634",urgence:'119',email: "r@gmail.com", password: "r@gmail.com",iduser:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}",confirmed_at:Date.today)
    user = User.create(name:'Run',first_name:'bnb',sexe:'homme',date_of_birth:'12/09/92',adresse:'Tana',mobile:"+261390987634",urgence:'119',email: "ra@gmail.com", password: "ra@gmail.com",iduser:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}",confirmed_at:Date.today)
    user2 = User.create(name:'Runs',first_name:'bnb',sexe:'homme',date_of_birth:'12/09/92',adresse:'Tana',mobile:"+261390987634",urgence:'119',email: "raharimalalarolland@gmail.com", password: "rakoto@gmail.com",iduser:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}",confirmed_at:Date.today)
    user3 = User.create(name:'Sedera',first_name:'mety',sexe:'homme',date_of_birth:'12/09/92',adresse:'Tana',mobile:"+261390987634",urgence:'119',email: "iantsaraz02@gmail.com", password: "a@gmail.com",iduser:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}")
    admin = AdminRun.create(name:"Runbnb",first:"bnb",email:"run@gmail.com",password:"run@gmail.com",statu: "actif", pseudo: "Run@site", mobile: "767867868767", adresse: "15 BP sud, rue Radu,ville st Paul", niveau: "2",idadmin:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}")
    AdminRun.create(name:"Test",first:"test",email:"test@testgmail.com",password:"test@testgmail.com",statu: "actif", pseudo: "Run@site", mobile: "767867868767", adresse: "15 BP sud, rue Radu,ville st Paul", niveau: "2",idadmin:"#{Time.now.year.to_s[-2]}#{Time.now.year.to_s[-1]}#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}")
    
    puts "user"

        @logement1 = Logement.new(id:2,name:"Villa",types:"Appartement",categorie:"Chambre privé",idlogement:"21#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}")
        @logement1.user_id = user0.id
        @logement1.save!
        
        puts "Logement"
        @logement = @logement1
        TaxeDeSejour.create(logement_id:@logement.id)
        puts "taxe"
        
    @chambre = Chambre.create(title:"Chambre",logement_id:@logement.id)

    puts "Chambre"

    @bain_entier = BainEntier.create(title:"Salle de bain entière : Toilette, lavabo, douce et baignoire
    ",quantite: 1,logement_id: @logement.id)

    @bain_demi = BainDemi.create(title:"Demi-salle de bain : Toilette et lavabo
    ",quantite: 1,logement_id: @logement.id)

    @cuisine = Cuisine.create(title:"Cuisine entière
    ",quantite: 1,logement_id: @logement.id)

    @kitchenette = Kitchenette.create(title:"Kitchenette : un espace compact pour préparer à manger
    ",quantite: 1,logement_id: @logement.id)

    puts "Equipement"

    @adresse = Adresse.new(pays:"La réunion",ville:"Basse Vallée",adresse:"Aude - 11 - Languedoc Roussillon Midi Pyrénées",code:"974")
    @adresse.logement_id = @logement.id
    @adresse.save

    puts "Adresse"


    @map = Map.new(longitude:55.69982829067352,latitude:-21.351144425787524,zoom:8)
    @map.logement_id = @logement.id
    @map.save

    puts "Map"

    @nombre = Nombrepersonne.new(number:3)
    @nombre.logement_id = @logement.id
    @nombre.save

    puts "Nombre de pérsonne"

    salon = Salon.create(title: "Salon",logement_id: @logement.id)
    lits = Canape.new(name:"Canapés",quantite:0,checked:false)
    lits.salon_id = salon.id
    lits.save 
    @a = Canape.new(name:"Canapés lits",quantite:2,checked:true)
    @a.salon_id = salon.id
    @a.save 

    puts "Salon"

    aautre = Autre.create(title: "Autre espace",logement_id: @logement.id)
    lits = Autrelit.new(name:"Lit Simple",quantite:1,checked:true)
    lits.autre_id = aautre.id
    lits.save 

    @autre01= Autrelit.new(name:"Lit Double",quantite:0,checked:false)
    @autre01.autre_id = aautre.id
    @autre01.save
    @autre02 = Autrelit.new(name:"Lit Famille",quantite:0,checked:false)
    @autre02.autre_id = aautre.id
    @autre02.save 

    puts "Autre"

    ParmsReservation.create(title:"Non fumeur",autre:" ",logement_id:@logement.id)


    @regle = Regle.new(arrive1:"08:00",arrive2:"12:00",depart1:"08:00",depart2:"12:00")
    @regle.logement_id = @logement.id
    @regle.save

    puts "Regle"

    @cal = Calendrier.new(startDate:"2020-03-14",endDate:"2021-03-17", delaimin: 2, nuitmin: 4, ouvrir:"yes", logement_id:@logement.id, tarif: 43)
    @cal.logement_id = @logement.id
    @cal.save

    puts "Calendrier"

    @condition = Condition.new(conditions:"7 jours")
    @condition.logement_id = @logement.id
    @condition.save

    puts "Condition"


    lits = [{checked:false,quantite:0,name:"Lit Double"},{checked:false,quantite:0,name:"Lit Simple"},{checked:false,quantite:0,name:"Lit King-size"},{checked:false,quantite:0,name:"Lit Superposé"},{checked:false,quantite:0,name:"Canapé lit"},{checked:false,quantite:0,name:"Canapé lit double"},{checked:false,quantite:0,name:"Futon"}]
    lits.each do |lit|
        @lits = Lit.new(name:lit[:name],quantite:lit[:quantite],checked:lit[:checked])
        @lits.chambre_id = @chambre.id
        @lits.save     
    end

    puts "Lit"

    EquiCourant.create(title:"Bar",logement_id: @logement.id)
    EquiFamille.create(title:"Bar",logement_id: @logement.id)
    EquiLogistique.create(title:"Bar",logement_id: @logement.id)
    EquiSecurite.create(title:"Bar",logement_id: @logement.id)
    EquiSuplementaire.create(title:"Bar",logement_id: @logement.id)
    AccesVoyageur.create(acces:" ",aide1:" ",aide2:" ",autre:" ",presentation:" ",transport:" ",logement_id:@logement.id)
    RessouceVoyageur.create(title:" ",logement_id:@logement.id)

    puts "Equipemet"

    Caution.create(montant:"123",type_de_payment:"Carte bancaire",logement_id: @logement.id)
    FraisSuple.create(types:"Consommation eau",montant:12,facturation:"/séjour")
    FraisSuple.create(types:"Consommation gaz",montant:1,facturation:"/séjour")
    Commissiontax.create(commission:35,logement_id:@logement.id)

    puts "Frais"

    ids =[user.id,user2.id,user3.id]
    3.times do |i|
        Reservation.create(arrivee:Faker::Date.between(from: '2020-12-20', to: '2021-01-8'),
        depart:Faker::Date.between(from: '2021-01-09',
        to: '2021-01-18'),status:"annuler",commission:35,
        idreservation:"21#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}",
        duree:10,montan_total:401,commition_et_frais:171,
        tarif:23,nombre_personne:13,numero_credit:"1212121131311",user_id:ids[i],logement_id:@logement.id)    
    end
    4.times do |i|
        Reservation.create(arrivee:Faker::Date.between(from: '2021-01-07', to: '2021-01-12'),
        depart:Faker::Date.between(from: '2021-01-09', to: '2021-01-18'),
        status:"accepter",commission:35,duree:10,montan_total:401,
        idreservation:"21#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}",
        commition_et_frais:171,tarif:23,nombre_personne:13,
        numero_credit:"1212121131311",user_id:user0.id,logement_id:@logement.id)    
    end
    4.times do |i|
        Reservation.create(arrivee:Faker::Date.between(from: '2020-08-07', to: '2020-09-12'),
        depart:Faker::Date.between(from: '2020-09-18', to: '2020-09-24'),
        status:"En attente",commission:35,duree:10,montan_total:401,
        idreservation:"21#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}",
        commition_et_frais:171,tarif:23,nombre_personne:13,
        numero_credit:"1212121131311",user_id:user0.id,logement_id:@logement.id)    
    end
    4.times do |i|
        Reservation.create(arrivee:Date.today-4,
        depart:Date.today+13,
        status:"En attente",commission:35,duree:10,montan_total:401,
        commition_et_frais:171,tarif:23,nombre_personne:13,
        idreservation:"21#{[*('a'..'z')].sample(2).join}#{rand(1111...9999)}",
        numero_credit:"1212121131311",user_id:user0.id,logement_id:@logement.id)    
    end
    puts "Résérvation"

    conversation1 = Conversation.create(user_id:user.id,logement_id:@logement.id)     
    conversation2 = Conversation.create(user_id:user2.id,logement_id:@logement.id)     
    conversation3 = Conversation.create(user_id:user3.id,logement_id:@logement.id)     

    conversation1.messages.new(content:"Bonjour!",conversation_id:conversation1.id,is_client:true)
    conversation1.save

    conversation2.messages.new(content:"Bonjour!",conversation_id:conversation2.id,is_client:false)
    conversation2.save

    conversation3.messages.new(content:"Bonjour!",conversation_id:conversation3.id,is_client:true)
    conversation3.save

    puts "Conversation Client"

    conversation4 = ConverAdmin.create(admin_run_id:admin.id,logement_id:@logement.id)
        
    conversation4.message_admins.new(content:"Bonjour! ",conver_admin_id:admin.id,is_admin:admin.id)
    conversation4.save
    puts "Conversation Runbnb"


    5.times do |i|
        Photo.create!(:legend => nil, photo: File.open(File.join(Rails.root, "/public/imageseed/#{i}.jpeg")),logement_id:@logement.id)
    end
    puts "Photo"
    res5 = Reservation.last.id
    res4 = Reservation.find(res5 -9)
    res6 = Reservation.find(res5 -1)
    res7 = Reservation.find(res5 -2)

    FactureVersement.create!(numreservation:res4.idreservation,voyageur:"Test 1",montantnet:400,datedevirment:Date.today-4,sejour:"20/03 - 28/03",tariftotal:475,commission:50,taxe:25,logement_id:@logement.id,user_id:user.id,idProrio:user.iduser,nomProprio:"#{user.first_name}#{" "}#{user.name}",sanstaxe:450,statut:"Terminé",created_at:"2021-01-27 10:10:35")
    FactureVersement.create!(numreservation:Reservation.last.idreservation,voyageur:"Test 2",montantnet:500,datedevirment:Date.today+3,sejour:"21/05 - 27/05",tariftotal:575,commission:50,taxe:25,logement_id:@logement.id,user_id:user2.id,idProrio:user2.iduser,nomProprio:"#{user2.first_name}#{" "}#{user2.name}",sanstaxe:550,statut:"En attente",created_at:"2021-04-27 10:10:35")
    FactureVersement.create!(numreservation:res6.idreservation,voyageur:"Test 3",montantnet:400,datedevirment:Date.today+7,sejour:"06/06 - 10/05",tariftotal:475,commission:50,taxe:25,logement_id:@logement.id,user_id:user3.id,idProrio:user3.iduser,nomProprio:"#{user3.first_name}#{" "}#{user3.name}",sanstaxe:450,statut:"En attente",created_at:"2021-05-27 10:10:35")
    FactureVersement.create!(numreservation:res7.idreservation,voyageur:"Test 4",montantnet:400.25,datedevirment:Date.today+30,sejour:"20/0 - 27/05",tariftotal:475,commission:50,taxe:25,logement_id:@logement.id,user_id:user.id,idProrio:user.iduser,nomProprio:"#{user.first_name}#{" "}#{user.name}",sanstaxe:450,statut:"En attente",created_at:"2021-05-27 10:10:35")

    puts "Facture"
