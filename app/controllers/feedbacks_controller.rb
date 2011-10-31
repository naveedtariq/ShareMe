class FeedbacksController < ApplicationController

  def new
	 @feedback = Feedback.new
   
  end
	
	def create
    @feedback = Feedback.new(params[:feedback])
    if verify_recaptcha
      if @feedback.save
				Notifications.send_email(@feedback).deliver	
        redirect_to root_path and return
      end
    end
    @feedback.valid?
    @feedback.errors.add_to_base("Invalid Captcha.")
		render :action => :new
	end

	def thanks
	end

end
