class CompteMailer < ApplicationMailer
    
    def welcome_email(user)
        @user = user
        @url  = ENV['CLIENT_URL']
        mail(to: @user.email, subject: 'Bienvenue chez Runbnb') 
    end
end
