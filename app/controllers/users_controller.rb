class UsersController < ApplicationController
#########	layout "application", :only => [:new, :create]
	layout "default", :except=> [:new, :create]
  before_filter :authenticate_user!
  before_filter :correct_redirect
#	before_filter :require_no_user, :only => [:new, :create]
#	before_filter :require_user, :only => [:user_home,:edit,:update]


#	def new
#		@user = User.new
#	end

#	def create
#  	@user = User.new params[:user]
#		@user.is_local = true
#
#		@user.save do |result|
#			if result 
#				@user.deliver_activation_instructions!
#
#				if request.xhr?
#					flash[:notice] = "Congratulations! The way you communicate just got upgraded. A simple 4 digit ShareMe is all you will ever need, check your email now."
#					render :json => {:result=>"success",:message =>"Congratulations! The way you communicate just got upgraded. A simple 4 digit ShareMe is all you will ever need, check your email now."}	
#				else
#					flash[:notice] = "Congratulations! The way you communicate just got upgraded. A simple 4 digit ShareMe is all you will ever need, check your email now."
#					redirect_to :controller => "home", :action => "index"
#				end
#			else
#			if request.xhr?
#					render :json => {:result=>"failure",:message=>"There are errors with the following fields",:error=>@user.errors.full_messages}
#				else
#					render :action => :new
#				end
#			end
#		end
#	end

	def user_home
	end

  def edit
    @user = current_user
    @profile = @user.profile
  end

  def update
    @user = current_user
    @user.update_attributes(params[:user])
    @user.profile.update_attributes(params[:profile_attributes])
    flash[:success] = "Your Profile Has Been Updated Successfully!"
    redirect_to "/user_home" and return
    render :action => :user_home
  end

  def correct_redirect
    if session[:code].present?
      redirect_to search_path(session[:code]) and return
    end
  end
end
