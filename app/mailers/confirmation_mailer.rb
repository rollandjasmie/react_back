class ConfirmationMailer < ApplicationMailer
  def send_confirmation(user)
    @user = user
    @token = @user.confirmation_token
    @url = ENV["SERVER_URL"]
    puts @url
    mail(to: @user.email, subject: 'Confirmation inscription') 
  end
end
