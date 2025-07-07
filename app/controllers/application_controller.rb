class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    boards_path
  end
end
