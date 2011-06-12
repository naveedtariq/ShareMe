class Dashboard::UploadContactsController < Dashboard::ApplicationController

  def new
  end

  def create
    Contact.import_from_xls(current_user, params[:file].path)
    redirect_to dashboard_contacts_path, :notice => "Contacts upload."
  end
end
