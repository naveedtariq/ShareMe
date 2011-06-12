class SharemeController < ApplicationController

  def index
  end

  def show
    session[:shareme_code] = session[:connect_user_id] = nil
    if params[:code]
      if @user = User.find_by_code(params[:code])
        session[:shareme_code] = params[:code]
        session[:connect_user_id] = @user.id
        current_user.add_contact(@user, true) if authenticate_user!
      else
        flash[:alert] = "ShareMe code not found."
        redirect_to root_path
      end
    else
      session[:shareme_code] = session[:connect_user_id] = nil
      redirect_to root_path
    end

  end
end
