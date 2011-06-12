class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :shareme_code
  private

  # Redirect to user profile after sign in
  #
  def after_sign_in_path_for(resource_or_scope)
    if shareme_code.present?
      shareme_code_path(shareme_code)
    else
      dashboard_users_path
    end
  end

  def check_filled_account!
    redirect_to finish_register_path if current_user && !current_user.filled?
  end
  def shareme_code
    session[:shareme_code]
  end
end
