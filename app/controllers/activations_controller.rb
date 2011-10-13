class ActivationsController < ApplicationController
#before_filter :require_no_user, :only => [:new, :create]

	def new
		@user = User.find_using_perishable_token(params[:activation_code],1.week) || (raise Exception)
		raise Exception if @user.active? && @user.is_local
	end

	def create
  	@user = User.find(params[:id])
	  raise Exception if @user.active? && @user.is_local
		if @user.activate!(params)
	  	@user.deliver_activation_confirmation!
      @user.update_name
      @user.save

			flash[:success] = "You now have your very own 4 digit ShareMe. No more business cards and email addresses just ShareMe."
			redirect_to user_home_path
		else
			render :action => :new
		end
	end

end
