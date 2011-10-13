class ApplicationController < ActionController::Base
#  protect_from_forgery
	helper_method :current_user_session, :current_user

  private
    def current_user_session
			@current_user_session ||= UserSession.find
    end

    def current_user
      @current_user ||= current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        if session[:return_to].to_s.include?("search")
          flash[:notice] = "If you want to connect with '" + session[:params][:code].upcase + "', Please Sign In to continue."
        else
          flash[:notice] = "You must be logged in to access this page"
        end
        redirect_to :root
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to user_home_path
        return false
      end
    end

    def store_location
      session[:return_to] = request.fullpath
      session[:params] = request.params
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

end
