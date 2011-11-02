class InvitationsController < Devise::InvitationsController
	def edit 
		@user = User.find_by_invitation_token(params[:invitation_token])
		unless @user
			flash[:error] = 'Invalid invitation token!'
			redirect_to root_path and return
		end
	end
	
	def update
		@user = User.accept_invitation!(params[:user])

		if @user.errors.empty?
		  	flash[:success] =  "Registeration completed successfully!"
			redirect_to root_path and return
		else
		  respond_with_navigational(@user){ render_with_scope :edit }
		end
	end
end
