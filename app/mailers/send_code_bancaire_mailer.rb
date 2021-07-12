class SendCodeBancaireMailer < ApplicationMailer
    def code(user,code)
        @user=user
        @code=code
        mail(to: @user.email, subject: 'modification des coordonnées bancaire') 
    end
end
