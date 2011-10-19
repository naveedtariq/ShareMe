class UsersController < ApplicationController
	layout "default", :except=> [:new, :create]
  before_filter :authenticate_user!, :except => [:update_user_for_password]
  before_filter :correct_redirect

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

  def update_user_for_password
    token = UserToken.find_by_uid(session[:omniauth]["uid"]) if session[:omniauth] && session[:omniauth]["uid"]
    if token
      user = token.user if token.user
      if user
        user.update_attributes(params[:user])
        if user.valid?
          user.send_confirmation_instructions
          return render :json=>{:user => user}
        end
          return render :json=>{:user => user, :errors => user.errors}
      end
    end
  end

  def correct_redirect
    if session[:code].present?
      redirect_to search_path(session[:code]) and return
    end
  end

  def socialify
  end

    def get_facebook_feed
#      fb_status_feed ||= JSON.parse(current_user.facebook_access_token.get("/me/home"))["data"]
#      fb_status_feed ||= JSON.parse(current_user.facebook_access_token.get("/me/friends"))["data"]
#      id = 668328382
#      hay = current_user.facebook_access_token.post("/"+id.to_s+"/feed",:link=>"http://google.com",:message=>"hi")     
#      return render :text=>hay
#      return render  :json=>fb_status_feed
    end
    def get_tweets
        tweets ||= JSON.parse(current_user.twitter_access_token.get("/1/statuses/home_timeline.json").body)
      return render  :json=>tweets
    end
    def get_linkedin
      linkedin ||= JSON.parse(current_user.linked_in_access_token.get("/v1/people/~/network/updates?type=SHAR", 'x-li-format' => 'json').body)
      return render  :json=>linkedin.values
    end

end
