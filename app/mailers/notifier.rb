class Notifier < ActionMailer::Base
  default :from => "admin@shareme.com"
	def activation_instructions(user)
		subject       "Welcome to ShareMe ~ Time to upgrade your communications."
		from          "Share Me <noreply@shareme.com>"
		recipients    user.email
		sent_on       Time.now
		body          :account_activation_url => register_url(user.perishable_token),:user_email=> user.email
	  end
		 
	def activation_confirmation(user)
		subject       "Share Me ~ ShareMe Code"
		from          "Share Me <noreply@shareme.com>"
		recipients    user.email
		sent_on       Time.now
		body          :root_url => root_url,:code => user.code
	end
end
