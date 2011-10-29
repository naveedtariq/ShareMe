class GroupsController < ApplicationController
	layout "default"
  before_filter :authenticate_user!

  def index
    @LinksA = current_user.links.where(:group_id => 1)
    @LinksB = current_user.links.where(:group_id => 2)
    @LinksC = current_user.links.where(:group_id => 3)
    @LinksD = current_user.links.where(:group_id => 4)
    @LinksE = current_user.links.where(:group_id => 5)
  end
  
  def change
  	unless @contact =  current_user.contacts.where(:id => params[:id]).first
  		flash[:error] = "User not found!"
  		redirect_to contacts_path
  	end
  end
 
  def update
    if params[:id]
	  	current_user.add_or_update_contact(params[:id], params[:newgroup])
	  	redirect_to groups_path
	else
		flash[:error] = "No changes submitted!"
  		redirect_to groups_path
	end
  end

end
