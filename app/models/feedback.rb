class Feedback < ActiveRecord::Base
	validates :first_name, :presence => true
	validates :email, :presence => true
	validates :comments, :length => {:minimum => 20 }
end
