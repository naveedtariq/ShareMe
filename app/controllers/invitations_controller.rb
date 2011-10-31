class InvitationsController < Devise::InvitationsController
	def edit 
		@u = User.find_by_invitation_token(params[:invitation_token])
		unless @u	
			flash[:error] = 'invalid invitation token!'
			redirect_to root_path and return
		end
	end
	def update
		@u = User.accept_invitation!(params[:user])
		
		if @u.errors.empty?
			#TODO: add to contacts
			@u.add_or_update_contact @u.invited_by.id
			@u.send_confirmation_instructions
			redirect_to root_path and return
		end
		@u.password = nil
		render :edit
	end
end
