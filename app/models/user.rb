class User < ActiveRecord::Base
#acts_as_authentic

	before_validation :generate_code,     :if => lambda{ |t| t.code.blank? }
  before_save :test

	acts_as_authentic do |c|
		c.login_field = "email"
	  c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
		c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
		c.validate_login_field = false  #don't validate email field with additional validations
	end



  has_many :contacts, :dependent => :destroy
  has_many :associated_contacts, :class_name => "Contact", :foreign_key => :associated_user_id
  has_one :profile, :dependent => :destroy
  accepts_nested_attributes_for :profile, :allow_destroy => true


	include SocialProfile


	def test
		if (self.new_record?) && (!self.access_tokens.empty?)
			self.active = true
			self.name = self.social_profile[:name]
		end
	end

	def active?
		active 
	end

	def activate!(params)
		self.active = true
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    self.phone = params[:user][:phone]
    self.email = params[:user][:email] if params[:user][:email]
    self.update_info_from_social_profile if !self.is_local
    self.is_local = true
    self.build_profile
    self.profile.update_profile(self)
    self.profile.save
		save
	end

	def deliver_activation_instructions!
		reset_perishable_token!
		Notifier.activation_instructions(self).deliver!
	end
	 
	def deliver_activation_confirmation!
		reset_perishable_token!
		Notifier.activation_confirmation(self).deliver!
	end


	def has_no_credentials?
	  self.crypted_password.blank? 
	end

	def signup!(params)
		self.update_attributes params[:user]
		save_without_session_maintenance
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

# update users' first name and last name
  def update_name
    names = self.name.split(' ')
    if names.length > 1
      fname = names[0]
      lname = self.name.gsub(names[0]+" ","")
    end
    self.f_name = fname
    self.l_name = lname
  end

  def update_info_from_social_profile
    self.email = self.social_profile[:email] unless self.social_profile[:email].blank?
    self.name = self.social_profile[:name] unless self.social_profile[:name].blank?
    self.update_name
    self.phone = self.social_profile[:phone] unless self.social_profile[:phone].blank?
  end

#Add a single contact
  def add_contact(contact, and_add_self_to_contact = false)
    if @exists_contact = contacts.email_or_associated_user_id(contact.email, contact.id).first
      @exists_contact.update_attribute(:associated_user, contact)
    else
      @exists_contact = contacts.create({:associated_user => contact })
    end
    contact.add_contact(self) if and_add_self_to_contact
    @exists_contact
  end
end
