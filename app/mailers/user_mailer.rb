class UserMailer < ApplicationMailer
    
    def welcome_email(user,logement,currentu)
        @user = user
        @logement = logement 
        @current_user = currentu
        @url  = ENV['CLIENT_URL']
        mail(to: @user.email, subject: 'Bienvenue chez Runbnb') 
    end
end
