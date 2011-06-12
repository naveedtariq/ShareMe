class Dashboard::ImportContacts::FacebookController < Dashboard::ImportContacts::ApplicationController
  before_filter :prepare_auth_params, :only =>  :friends

  # View list friends
  #
  def friends
    if auth_params[:email].present? && auth_params[:password].present? &&
        ( @import_contact = ImportContact::Facebook.new(current_user, { :cookies => cookies }) )
	puts "Params Found Done!!!!!"
      if @import_contact.auth?
	puts "Auth Done!!!!!"
        if ImportContact::Facebook.auth_mechanize?(auth_params)
		puts "Mecha Done!!" 
          @friends = @import_contact.friends
        else
          redirect_to dashboard_import_contacts_path, :error => "Facebook: Shady password or email."
        end

      else
        session["user_return_to"] = dashboard_facebook_friends_path
        redirect_to omniauth_authorize_path(:user, :facebook)
      end
    else
      redirect_to dashboard_import_contacts_path, :alert => "Need fill email and password."
    end
  end

  # Import of selected friends
  #
  def imports
	puts params.inspect + "--------------------"
    if params[:users].present?
      @contacts = ImportContact::Facebook.import(current_user, {
                                                   :password => auth_params[:password],
                                                   :email => auth_params[:email], :contact_uids => params[:users]
                                                 })
      session.delete(:import_contact_params)
      flash.notice = "Contacts imported."
    else
      redirect_to dashboard_contacts_path, :notice => "Not selected contacts."
    end
	render :json => @contacts
  end

  def invite
    if params[:users].present?
      User.where(:id => params[:users]).map{ |v| v.invite!}
      redirect_to dashboard_contacts_path, :notice => "Invites sent."
    else
      redirect_to dashboard_contacts_path, :notice => "Not selected contacts."
    end
  end

  private

  def prepare_auth_params
    session[:import_contact_params] ||= { }
    session[:import_contact_params][:email]    = params[:email]    if params[:email].present?
    session[:import_contact_params][:password] = params[:password] if params[:password].present?
  end

  def auth_params
    session[:import_contact_params] ||= { }
    session[:import_contact_params]
  end

end
