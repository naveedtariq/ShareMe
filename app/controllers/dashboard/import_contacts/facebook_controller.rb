class Dashboard::ImportContacts::FacebookController < Dashboard::ImportContacts::ApplicationController
  before_filter :prepare_auth_params, :only =>  :friends

  layout Proc.new { |controller| controller.request.xhr? ? nil : 'application' }

  # View list friends
  #
  def friends
    if auth_params[:email].present? && auth_params[:password].present? &&
        ( @import_contact = ImportContact::Facebook.new(current_user, { :cookies => cookies }) )
      if @import_contact.auth?
        if ImportContact::Facebook.auth_mechanize?(auth_params)
          @friends = @import_contact.friends
          if request.xhr?
            #debugger
            current_user.update_attribute(:first_signin_fb, false)
            render 'friends_box' and return
          end
        else
          respond_to do |format|
            format.html { redirect_to dashboard_import_contacts_path, :error => "Facebook: Shady password or email."}
            format.xml { render :text => "error|Facebook: Shady password or email." }
          end
        end

      else
        session["user_return_to"] = dashboard_facebook_friends_path
        redirect_to omniauth_authorize_path(:user, :facebook)
      end
    else
      respond_to do |format|
        format.html { redirect_to dashboard_import_contacts_path, :alert => "Need fill email and password."}
        format.xml { render :text => "error|Need fill email and password." }
      end
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
    @contacts.each do |c|
      User.find_by_id(c[0].id).invite!
    end
#  User.where(:id => @contacts).map{ |v| v.invite!}
	render :text => dashboard_contacts_path.to_s
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
