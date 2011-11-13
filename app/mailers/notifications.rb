class Notifications < ActionMailer::Base
	
  default :To => "admin@shareme.com"


	def send_email (feedback)
		subject       "A Comment from #{feedback.first_name} #{feedback.last_name}"
		from          "#{feedback.email}"
		recipients    "admin@shareme.com" 
		sent_on       Time.now
		body          :feedback => feedback
  end

end

