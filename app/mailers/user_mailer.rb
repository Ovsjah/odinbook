class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send_welcome.subject
  #
  def send_welcome_to(user)
    @user = user
    mail(
      to: @user.email,
      template_name: :welcome,
      subject: "Welcome to Odinbook, #{@user.username}."
    )
  end
end
