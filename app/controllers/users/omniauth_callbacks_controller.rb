class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user

  User::PROVIDERS.each do |provider|
    define_method provider do
      if @user.persisted?
        sign_in_and_redirect @user
        set_flash_message(:notice, :success, kind: "#{provider.humanize.split(' ').first}")
      else
        redirect_to new_user_session_path,
          alert: "Failed to authenticate with #{provider.humanize}. #{@user.errors.full_messages.join('\n')}"
      end
    end
  end

  protected

    def set_user
      @user = User.from_omniauth(request.env['omniauth.auth'])
    end
end
