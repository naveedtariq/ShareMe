class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  attr_accessor :omniauth_data
  attr_accessor :preexisting_authorization_token

  before_filter :set_omniauth_data

  def method_missing(provider)
    return super unless valid_provider?(provider)
    omniauthorize_additional_account || omniauth_sign_in || omniauth_sign_up
    return
  end

  protected

  def omniauth_sign_in
#debugger
    #todo merge by email if signing in with a new account for which we already have a user (match on email)
    return false unless preexisting_authorization_token

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider']
#    render :text => "ask for friends here!!!" and return 
   sign_in_and_redirect(:user, preexisting_authorization_token.user)
    true
  end


  def omniauth_sign_up
#debugger
    user = unless omniauth_data.recursive_find_by_key("email").blank?
             User.find_or_initialize_by_email(:email => omniauth_data.recursive_find_by_key("email"))
           else
             User.new
           end

    user.apply_omniauth(omniauth_data)
    user.first_signin_fb = true

    if user.save(:validate => false)
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider']
      sign_in(user, :bypass => true)
   #   render :text => "ask for friends here!!!" and return true
      #redirect_to dashboard_users_path
       sign_in_and_redirect(:user, user)
    else
      session[:omniauth] = omniauth_data.except('extra')
      redirect_to new_user_registration_url
    end
  end


  def omniauthorize_additional_account
    return false if current_user.nil?

    #todo signin not necessary, may mess up last sign in dates
    if preexisting_authorization_token && preexisting_authorization_token.user != current_user
      flash[:alert] = "You have created two accounts and they can't be merged automatically."
      sign_in_and_redirect(:user, current_user)
    else

      current_user.apply_omniauth(omniauth_data)
      current_user.save

      flash[:notice] = "Account connected"
    #render :text => "ask for friends here!!!" and return 
      sign_in_and_redirect(:user, current_user)
    end

  end


  def set_omniauth_data
    self.omniauth_data = env["omniauth.auth"]
    self.preexisting_authorization_token = UserToken.find_by_provider_and_uid(omniauth_data['provider'], omniauth_data['uid'])
  end


  def valid_provider?(provider)
    !User.omniauth_providers.index(provider).nil?
  end

end
