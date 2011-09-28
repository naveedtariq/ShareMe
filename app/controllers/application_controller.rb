class ApplicationController < ActionController::Base
#  protect_from_forgery
  helper_method :shareme_code
  private

# Redirect to user profile after sign in
#
  def after_sign_in_path_for(resource_or_scope)
    puts "i was hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
    puts shareme_code.inspect + "11111111111111111111111111111111111111111111111111111111111!"
    if shareme_code.present?
      puts "inside ifffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
      "/search?code="+shareme_code
    else
      puts "inside elseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
      contacts_path
    end
  end

  def shareme_code
    session[:code]
  end
end
