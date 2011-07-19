class HomeController < ApplicationController
	before_filter :require_no_user
  def index
		@user = User.new
  end

end
