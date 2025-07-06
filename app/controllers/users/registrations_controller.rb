# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "devise"

  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  protected

  # Permitir o campo :name no cadastro
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  # Permitir o campo :name na edição da conta
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
