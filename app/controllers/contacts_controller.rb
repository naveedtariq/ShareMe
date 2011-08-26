class ContactsController < ApplicationController
	layout "default"
  before_filter :require_user
  before_filter :verify_contacts, :only =>[:show]

  def index
    @contacts = current_user.contacts
    if params[:selected]
      @contact = current_user.contacts.find(params[:selected])
    else
      @contact = current_user.contacts.first
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
        @contact = current_user.add_contact(@user)
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
    if (@contact = current_user.contacts.find(params[:id])) && @contact.destroy
      flash.notice = "User with ShareMe Code \'#{@contact.associated_user.code}\' Has Been Deleted Successfully From You Contact List!"
    else
      flash[:error] = "There Was Some Error While Deleting Contact. Please Try Again Later!" 
    end
    redirect_to contacts_path
  end

  def search
    if params[:code] || session[:params][:code]
      if @user = User.find_by_code(params[:code]||session[:params][:code])
        current_user.add_contact(@user, true) 
        flash[:success] = "User With ShareMe Code \'#{@user.code}\' Found And Is Successfully Added To Your Contact List!" 
        redirect_to contacts_path and return
      else
        flash[:error] = "There is no User with \'" +( params[:code] || session[:params][:code]) + "\' ShareMe Code."
        redirect_to user_home_path
      end
    else
      redirect_to root_path
    end
  end

  def import_contacts
    
  end

  def show_basic_profile
    if params[:id]
      @contact = current_user.contacts.find(params[:id])
      return render :partial => "profile_view_index",:locals=>{:contact=>@contact}
    end
  end

  def verify_contacts
    contact = current_user.contacts.find(params[:id])
    if contact.blank?
      flash[:notice] = "There is no such contact in your list"
      redirect_to contacts_path
    end
  end
end
