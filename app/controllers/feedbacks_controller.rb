class FeedbacksController < ApplicationController
  def new
	 @feedback = Feedback.new
 	 	 
  end
	
	def create
		@feedback = Feedback.new(params[:feedback])
		if @feedback.save
			redirect_to thanks_feedbacks_path and return
		end
		render :action => :new
	end

	def thanks
	end

end
