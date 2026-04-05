class UserMailer < ApplicationMailer
  def confirmation(user)
    @user = user
    @confirmation_url = "#{ENV['FRONTEND_URL']}/confirm-email?token=#{user.confirmation_token}"

    mail(to: @user.email, subject: "Please confirm your email")
  end
end
