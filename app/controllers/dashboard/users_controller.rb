class Dashboard::UsersController < Dashboard::ApplicationController

  def show

  end

  def edit

  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to dashboard_users_path, :notice => "ShareMe profile updated"
    else
      render :edit
    end
  end

  def update_signin_fb_flag
    current_user.update_attribute(:first_signin_fb,false)
    return render :text=>""
  end

end
