class RegistrationsController < Devise::RegistrationsController

	def create
		puts "llllllllllllllllllllllllllllllllllllllllll"
		params[:user]["searched_code"] = session[:code]
		super
	end

end
