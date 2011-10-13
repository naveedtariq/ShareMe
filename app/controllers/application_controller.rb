class ApplicationController < ActionController::Base
#  protect_from_forgery
  helper_method :shareme_code
  private

# Redirect to user profile after sign in
#
  def after_sign_in_path_for(resource_or_scope)
    if shareme_code.present?
      "/search?code="+shareme_code
    else
      user_home_path
    end
  end

  def shareme_code
    session[:code]
  end
end
