class ConfirmationsController < Devise::ConfirmationsController

  def show
    @user = User.find_by_confirmation_token(params[:confirmation_token])
    if !@user.present?
      flash[:error] = "There is no user with this Confirmation Code or The user is already confirmed."
      redirect_to :root and return
    end
  end

  def confirm_user
    @user = User.find_by_confirmation_token(params[:user][:confirmation_token])
    if @user.update_attributes(params[:user]) and @user.password_match?
      @user = User.confirm_by_token(@user.confirmation_token)

      if request.xhr?
        @user.profile.phone = @user.phone
        sign_in(resource_name, resource)
        render :json => {:result=>"success",:message =>"Your Account Has Been Confirmed! Now You May Sign-In."}
      else
        set_flash_message :notice, :confirmed      
        sign_in_and_redirect("user", @user)
      end
    else
      if request.xhr?
        render :json => {:result=>"failure",:message=>"There are errors with the following fields",:error=>@user.errors.full_messages}
      else
        render :action => "show"
      end
    end
  end

end
