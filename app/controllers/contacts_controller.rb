class ContactsController < ApplicationController

	layout "default"
  before_filter :authenticate_user!, :except =>[:search]
  before_filter :verify_contacts, :only =>[:show]

  def index	    
    @contacts = current_user.contacts
    
    if params[:selected]
      @contact = current_user.contacts.find(params[:selected])
      @contactgroup = translate_group_id(current_user.links.where(:contact_id => @contact.id).first.group_id)
    else
      @contact = current_user.contacts.first
      unless @contact.blank?
        @contactgroup = translate_group_id(current_user.links.where(:contact_id => @contact.id).first.group_id)
      end
    end
  end

  def show
    @contact =  current_user.contacts.find(params[:id])
  end

  def new
  end

  def create
    if verify_recaptcha
      if params[:shareme_code].present? && (@user = User.find_by_code(params[:shareme_code]))
        @contact = current_user.add_or_update_contact(@user.id)
        @contacts = current_user.contacts
        flash[:success] = "User \'#{@user.code}\' Is Successfully Added To Your Contact List!"
        redirect_to contacts_path
      else
        flash[:error] = "There is no User with \'" + params[:shareme_code] + "\' ShareMe Code."
        #render :new
        redirect_to new_contact_path
      end
    else
      flash[:error] = "Captcha Doesn't Match! Please Try again!" 
      redirect_to new_contact_path
      #render :new
    end
  end

  def destroy
    if (@link = current_user.links.where(:contact_id => params[:id]).first) && @link.destroy
      flash.notice = "User with ShareMe Code \'#{@link.contact.code}\' Has Been Deleted Successfully From You Contact List!"
    else
      flash[:error] = "There Was Some Error While Deleting Contact. Please Try Again Later!" 
    end
    redirect_to contacts_path
  end

  def search
    session[:code] = session[:connect_user_id] = nil
    if params[:code]
      if @user = User.find_by_code(params[:code]||session[:params][:code])
        session[:code] = params[:code]
        session[:connect_user_id] = @user.id
        unless current_user
          flash[:error] = "'#{( params[:code] || session[:code]).upcase}' is a registered user. Please Register or Sign In to view the details of the User."
          redirect_to "/" and return
        end
        current_user.add_or_update_contact(@user.id)
        session[:code] = session[:connect_user_id] = nil
        flash[:success] = "User With ShareMe Code \'#{@user.code}\' Found And Is Successfully Added To Your Contact List!" 
        redirect_to contacts_path and return
      else
        flash[:error] = "'" + ( params[:code] || session[:code]).upcase + "' is not registered. Please try again."
        session[:code] = session[:connect_user_id] = nil
        redirect_to current_user.blank? ? root_path : user_home_path
      end
    else
      session[:code] = session[:connect_user_id] = nil
      redirect_to root_path
    end
  end

  def import_contacts
  end

  def post_on_wall
    ids = params["id"].split(",")
    ids.each do |id|
     current_user.post_on_fb(id) 
    end
    return render :json=>{:success=>true}
  end

  def get_facebook_friends
    @friends = current_user.get_facebook_friends_list
    render :partial => "friend_box" and return
  end

  def show_basic_profile
    if params[:id]
      @contact = current_user.contacts.find(params[:id])
	  @contactgroup = translate_group_id(current_user.links.where(:contact_id => @contact.id).first.group_id)
      return render :partial => "profile_view_index",:locals=>{:contact=>@contact}
    end
  end

  protected
  def verify_contacts
    contact = current_user.contacts.find(params[:id])
    if contact.blank?
      flash[:notice] = "There is no such contact in your list"
      redirect_to contacts_path
    end
  end
  
  def translate_group_id(id)
    map = {1 => 'A', 2 => 'B', 3 => 'C', 4 => 'D', 5 => 'E'}
	map[id]
  end
end
