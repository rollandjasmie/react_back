class PasswordMailer < ApplicationMailer
    def welcome_email(user)
        @user=user
        mail(to: @user.email, subject: 'Mot de passe oublié') 
    end
    def admin(admin)
        @user=admin
        mail(to: @user.email, subject: 'Mot de passe oublié') 
    end
    
end
