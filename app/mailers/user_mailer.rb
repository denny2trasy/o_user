class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #
  def reset_password(user,password)
    @user = user
    @password = password

    mail :to => @user.mail ,:subject => "Password reset!"
  end
end
