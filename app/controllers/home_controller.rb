class HomeController < ApplicationController
#	before_filter :require_no_user
  def index
		@user = User.new
    if params[:confirmation_token]
      @user = User.find_by_confirmation_token(params[:confirmation_token])
      if @user.present?
        @confirmation_token = @user.confirmation_token
      else
        flash[:error] = "There is no user with this Confirmation Code or The user is already confirmed."
      end
    end
  end

end
