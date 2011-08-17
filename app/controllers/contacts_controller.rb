class ContactsController < ApplicationController
	layout "default"
  before_filter :require_user

  def index
    @contacts = current_user.contacts
  end

# Show contact, only level1
#
  def show
    @contact =  current_user.contacts.find(params[:id])
  end

# Add User to my contacts via search ShareMe code
#
  def new

  end

# Add user to my contacts
#
  def create
    if verify_recaptcha
      if params[:shareme_code].present? && (@user = User.find_by_code(params[:shareme_code]))
        @contact = current_user.add_contact(@user)
        @contacts = current_user.contacts
        redirect_to contacts_path, :notice => "Contact Successfully Added"
      else
        flash[:error] = "There is no User with " + params[:shareme_code] + " ShareMe Code."
#render :new
        redirect_to new_contact_path
      end
    else
      flash[:recaptcha_error] = "Captcha Doesn't Match! Please Try again!" 
      redirect_to new_contact_path
#render :new
    end
  end

  def destroy
    if (@contact = current_user.contacts.find(params[:id])) && @contact.destroy
      flash.notice = "Contact deleted successfully"
    else
      flash[:error] = "Contact cannot be found" 
    end
    redirect_to contacts_path
  end
#TODO: need send email if a contact is newly added
  def search
    if params[:code] || session[:params][:code]
      if @user = User.find_by_code(params[:code]||session[:params][:code])
        current_user.add_contact(@user, true) 
        flash[:notice] = "Found and added into your contacts successfully!" 
        redirect_to contacts_path and return
      else
        flash[:error] = "ShareMe code not found."
        puts "I was here" + "sssssssssssssssssssssssssssssssss " + flash[:error]
        redirect_to user_home_path
      end
    else
      redirect_to root_path
    end
  end

  def import_contacts
    
  end
end
