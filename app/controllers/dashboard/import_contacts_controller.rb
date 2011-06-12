class Dashboard::ImportContactsController < Dashboard::ApplicationController
  def index
    session.delete(:import_contact_params)
  end
end
