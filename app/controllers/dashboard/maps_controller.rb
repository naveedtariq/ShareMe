class Dashboard::MapsController < Dashboard::ApplicationController
  include ApplicationHelper

  def index
    @contacts =  current_user.contacts
    @contacts_data =  @contacts.map{ |v| { :address => v.associated_user.try(:address),
        :info => google_usercart(v.associated_user),
        :name => (v.associated_user.try(:full_name)||v.name),
        :url => dashboard_contact_path(v)}}
  end

  def show
  end
end
