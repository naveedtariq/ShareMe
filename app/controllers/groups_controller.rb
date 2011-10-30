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
    session[:return_to] = request.referer
  	if request.referer.index("http://localhost.com/contacts")
		puts session[:return_to] = 'http://localhost.com/contacts?selected=' + params[:id]
  	end
  	
  	unless @contact =  current_user.contacts.where(:id => params[:id]).first
  		flash[:error] = "User not found!"
  		redirect_to session[:return_to]
  	end
  	
  	@contactgroup = current_user.links.where(:contact_id => @contact.id).first.group_id
  end
 
  def update
    if params[:id]
	  	current_user.add_or_update_contact(params[:id], params[:newgroup])
	  	redirect_to session[:return_to]
	else
		flash[:error] = "No changes submitted!"
  		redirect_to session[:return_to]
	end
  end

end
