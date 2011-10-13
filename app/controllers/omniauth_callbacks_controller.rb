class OmniauthCallbacksController < Devise::OmniauthCallbacksController

 def method_missing(provider) 
    provider = params[:provider]
    omniauth = env["omniauth.auth"]
#    return render :json => omniauth

    if current_user #or User.find_by_email(auth.recursive_find_by_key("email"))
      user_token = current_user.user_tokens.find_or_create_by_provider_and_uid_and_token(omniauth['provider'], omniauth['uid'],omniauth['credentials']['token'])
      user_token.secret = omniauth['credentials']['secret'] if omniauth['credentials']['secret']
      user_token.save!
      flash[:notice] = "Authentication successful"
      @already = true
      @activation = true
      @dd = false
      render :action => "facebook" and return
#      redirect_to user_home_path
    else
      authentication = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      if authentication
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
        if authentication.user.confirmed_at
          @already = true
          @activation = true
          @dd = false
          sign_in(:user,authentication.user)
          render :action => "facebook" and return
        else
          @already = false
          @activation = false
          @dd= false
          flash[:error] = "You need to confirm your account before proceeding"
          render :action => "facebook" and return
        end
      else
        #create a new user
        unless omniauth.recursive_find_by_key("email").blank?
          user = User.find_or_initialize_by_email(:email => omniauth.recursive_find_by_key("email"))
        else
          user = User.new
        end
        user.apply_omniauth(omniauth)
        #user.confirm! #unless user.email.blank?
        puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        if user.save(:validate => false)
          puts "########################################################"
          session[:omniauth] = omniauth.except('extra')
          @already = false
          @activation = true
          @dd =true 
          render :action => "facebook" and return
          redirect_to new_user_registration_url
        end
      end
    end
  end
  
  def oauth_data
    type = params[:type]
    render :json => session[:omniauth]["user_info"].to_json
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end
