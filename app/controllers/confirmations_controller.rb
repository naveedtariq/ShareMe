class ConfirmationsController < Devise::ConfirmationsController
  # prepend_before_filter :require_no_authentication

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    session[:shareme_code] = params[:code] if params[:code]
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      flash.notice = "You now have your very own 4 digit ShareMe. No more business cards and email addresses just ShareMe"
      redirect_to finish_register_path
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render_with_scope :new }
    end
  end

end
