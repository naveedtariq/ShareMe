class Dashboard::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_filled_account!

end
