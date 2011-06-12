class RegistrationsController < Devise::RegistrationsController

  # POST /resource
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        if shareme_code
          set_flash_message :notice, :signed_up_with_shareme, { :shareme => shareme_code } if is_navigational_format?
        else
          set_flash_message :notice, :signed_up if is_navigational_format?
        end
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        if shareme_code
          set_flash_message :notice, :inactive_signed_up_with_shareme, { :shareme => shareme_code } if is_navigational_format?
        else
          set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
        end
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end



  # Last step registration
  #
  def finish
    @user = current_user
    if request.put? && @user.update_attributes(params[:user]) && @user.filled! && sign_in( @user, :bypass => true )
      redirect_to( (shareme_code.present? ? shareme_code_path(shareme_code) : dashboard_users_path),
                   :notice => I18n.t("controllers.profile_updated") )
    else
      render :finish
    end
  end

end
