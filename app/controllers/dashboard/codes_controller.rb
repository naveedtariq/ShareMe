class Dashboard::CodesController < Dashboard::ApplicationController

  def new
    @user = current_user
    @simular_code  = User.simular_code(@user.code)
  end

  def create
    @user = current_user
    @user.code = params[:user][:code] rescue nil
    if @user.save
      @user.send_notification_about_change_code
      redirect_to dashboard_users_path, :notice => I18n.t("dhb.codes.create.notice")
    else
      @simular_code  = User.simular_code(@user.code)
      render :new
    end

  end

end
