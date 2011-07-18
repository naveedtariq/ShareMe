class UsersController < ApplicationController
	before_filter :require_no_user, :only => [:new, :create]

	def new
		@user = User.new
	end

	def create
  	@user = User.new
		 
		if @user.signup!(params)
	  	@user.deliver_activation_instructions!
			flash[:notice] = "Congratulations! The way you communicate just got upgraded. A simple 4 digit ShareMe is all you will ever need, check your email now."
			redirect_to :controller => "home", :action => "index"
		else
			render :action => :new
		end
	end

end
