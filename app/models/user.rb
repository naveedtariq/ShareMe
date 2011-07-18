class User < ActiveRecord::Base
#acts_as_authentic

#attr_accessible :email, :password, :password_confirmation, :name
	validates_presence_of :name
	validates_uniqueness_of :name

	before_validation :generate_code,     :if => lambda{ |t| t.code.blank? }

	acts_as_authentic do |c|
		c.login_field = "email"
	  c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
		c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
		c.validate_login_field = false  #don't validate email field with additional validations
	end
	def active?
		active
	end

	def activate!
		self.active = true
		save
	end

	def deliver_activation_instructions!
		reset_perishable_token!
		Notifier.deliver_activation_instructions(self)
	end
	 
	def deliver_activation_confirmation!
		reset_perishable_token!
		Notifier.deliver_activation_confirmation(self)
	end


	def has_no_credentials?
	  self.crypted_password.blank? 
	end

	def signup!(params)
		self.login = params[:user][:name]
		self.email = params[:user][:email]
		self.name = params[:user][:name]
		save_without_session_maintenance
	end

	def activate!(params)
  	self.active = true
		self.password = params[:user][:password]
		self.password_confirmation = params[:user][:password_confirmation]
		save
	end

	# Generate random code
	#
	def generate_code
		charset = %w( 2 3 4 6 7 9 A C D E F G H J K L M N P Q R T V W X Y Z )
	  begin
			random = (0..3).map{ charset.to_a[rand(charset.size)] }.join
		end while User.find_by_code(random)
	  self.code = random
		self.code
	end
end
