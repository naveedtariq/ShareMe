class UserSessionsController < ApplicationController
	layout Proc.new { |controller| controller.request.xhr? ? nil : 'application' }
	before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
		@user_session.save do |result|
			if result 

#        if current_user && !current_user.is_local
#          puts "i was in is_local"
#          redirect_to register_url(current_user.perishable_token) and return
#        end
				if request.xhr?
					render :json => {:result=>"success",:message =>"Login successful!"}	
				else
					flash[:notice] = "Login successful!"
          if current_user && current_user.is_local == false
            redirect_to register_url(current_user.perishable_token)
          else
					  redirect_to current_user ? user_home_path : login_url
          end
				end
			else
        puts "I was in user sesion un-succcessfull save"
				if request.xhr?
					render :json => {:result=>"failure",:message=>"There are errors with the following fields",:error=>@user_session.errors.full_messages}
				else
					render :action => :new
				end
			end
		end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default "/" 
  end

end
