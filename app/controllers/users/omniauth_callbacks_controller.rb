class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    Rails.logger.debug "🔍 AUTH INFO: #{auth.inspect}"

    @user = User.from_omniauth(auth)
    Rails.logger.debug "🔍 USER ERROS: #{@user.errors.full_messages}" unless @user.persisted?

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: "Erro ao autenticar com Google."
    end
  end
end
