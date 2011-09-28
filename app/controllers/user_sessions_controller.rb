class UserSessionsController < ApplicationController
#	layout Proc.new { |controller| controller.request.xhr? ? nil : 'application' }
#	before_filter :require_no_user, :only => [:new, :create]
#  before_filter :require_user, :only => :destroy

#  def new
#    @user_session = UserSession.new
#  end

#  def create
#    @user_session = UserSession.new(params[:user_session])
#		@user_session.save do |result|
#			if result 
#				if request.xhr?
#					render :json => {:result=>"success",:message =>"Login successful!",:path => get_recent_path}	
#				else
#					flash[:notice] = "Login successful!"
#          if current_user && current_user.is_local == false
#            redirect_to register_url(current_user.perishable_token)
#          else
#            redirect_to get_recent_path
#          end
#				end
#			else
#				if request.xhr?
#					render :json => {:result=>"failure",:message=>"There are errors with the following fields",:error=>@user_session.errors.full_messages}
#				else
#					render :action => :new
#				end
#			end
#		end
#  end
#
#  def destroy
#    current_user_session.destroy
#    flash[:notice] = "Logout successful!"
#    redirect_to "/" 
#  end

#  def get_recent_path
#    if current_user
#      if session[:return_to]
#        r_path = session[:return_to]
#      else
#        r_path = user_home_path
#      end
#    else
#      r_path = root_url
#    end
#  end

end
