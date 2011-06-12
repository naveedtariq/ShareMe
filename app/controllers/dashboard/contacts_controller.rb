class Dashboard::ContactsController < Dashboard::ApplicationController

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
        redirect_to dashboard_contact_path(@contact), :notice => I18n.t("dhb.contacts.create.success")
      else
        flash[:error] = I18n.t("dhb.contacts.create.not_found")
        render :new
      end
    else
      flash[:recaptcha_error] = I18n.t("dhb.contacts.create.invalid_captcha")
      render :new
    end
  end

  def destroy
    if (@contact = current_user.contacts.find(params[:id])) && @contact.destroy
      flash.notice = I18n.t("successfully")
    else
      flash[:error] = I18n.t("dhb.contacts.destroy.not_found")
    end
    redirect_to dashboard_contacts_path
  end

end
