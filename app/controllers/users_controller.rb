class UsersController < ApplicationController
	layout "application", :only => [:new, :create]
	layout "default", :except=> [:new, :create]

	before_filter :require_no_user, :only => [:new, :create]
	before_filter :require_user, :only => [:user_home,:edit,:update]


	def new
		@user = User.new
	end

	def create
  	@user = User.new params[:user]
		@user.is_local = true

		@user.save do |result|
			if result 
				@user.deliver_activation_instructions!

				if request.xhr?
					puts "i was in ajax request"
					flash[:notice] = "Congratulations! The way you communicate just got upgraded. A simple 4 digit ShareMe is all you will ever need, check your email now."
					render :json => {:result=>"success",:message =>"Congratulations! The way you communicate just got upgraded. A simple 4 digit ShareMe is all you will ever need, check your email now."}	
				else
					puts "i was in normal request"
					flash[:notice] = "Congratulations! The way you communicate just got upgraded. A simple 4 digit ShareMe is all you will ever need, check your email now."
					redirect_to :controller => "home", :action => "index"
				end
			else
			if request.xhr?
					puts "i was in ajax request"
					render :json => {:result=>"failure",:message=>"There are errors with the following fields",:error=>@user.errors.full_messages}
				else
					puts "i was in normal request"
					render :action => :new
				end
			end
		end
	end

	def user_home
	end

  def edit
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update_attributes(params[:user])
    @user.profile.update_attributes(params[:profile_attributes])
    flash[:notice] = "Profile Successfully Updated!"
    redirect_to "/user_home" and return
#    render :action => :user_home
  end
end
