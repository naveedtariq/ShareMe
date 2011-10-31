class FeedbacksController < ApplicationController

  def new
	 @feedback = Feedback.new
 	 	 
  end
	
	def create
    @feedback = Feedback.new(params[:feedback])
    if verify_recaptcha
      if @feedback.save
      	flash[:success] = "Your feedback was submitted successfully!"
      	if user_signed_in?
      		redirect_to user_home_path and return
      	else
        	redirect_to root_path and return
        end
      end
    end
    @feedback.valid?
    @feedback.errors.add_to_base("Invalid Captcha.")
		render :action => :new
	end

	def thanks
	end

end
