class User < ActiveRecord::Base

	before_validation :generate_code,:if => lambda{ |t| t.code.blank? }
  before_create :update_name
  before_create :link_profile

  devise :invitable, :database_authenticatable, :registerable, :omniauthable,
          :recoverable, :rememberable, :trackable, :validatable, :confirmable, :invitable

  validates :name, :presence => true

  has_many :contacts, :dependent => :destroy
  has_many :associated_contacts, :class_name => "Contact", :foreign_key => :associated_user_id
  has_one :profile, :dependent => :destroy
  has_many :user_tokens, :dependent => :destroy


  accepts_nested_attributes_for :profile, :allow_destroy => true

  include SocialProfile

  def password_match?
    self.errors[:password] << 'password not match' if password != password_confirmation
    self.errors[:password] << 'you must provide a password' if password.blank?
    password == password_confirmation and !password.blank?
  end

  def confirmation_required?
    (!self.encrypted_password.blank?) && super
  end
	
	def self.generate_invitation_token
		generate_token(:invitation_token)
	end

		
	def invite_fb_users(user_name)
		a = User.new
		a.name = user_name
		a.invitation_token = generate_invitation_token 
		a.invited_by = self
		a.invitation_sent_at = Time.now.utc
		a.save(:validate => false)
		a.invitation_token
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
    if self.f_name.blank? && self.l_name.blank?
      names = self.name.split(' ')
      if names.length > 1
        fname = names[0]
        lname = self.name.gsub(names[0]+" ","")
      end
      self.f_name = fname
      self.l_name = lname
    end
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

  def link_profile
    if self.new_record?
      self.build_profile
      self.profile.phone = self.phone
      self.profile.company_name = self.social_profile[:company_name] if self.social_profile
      self.profile.save!
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    User.find_by_email(data["email"])
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    User.create(:name => data['name'])
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session[:omniauth]
        user.user_tokens.build(:provider => data['provider'], :uid => data['uid'])
      end
    end
  end
                                
  def apply_omniauth(omniauth)
    #add some info about the user
    self.name = omniauth['user_info']['name'] if name.blank?
    #self.nickname = omniauth['user_info']['nickname'] if nickname.blank?
    
    unless omniauth['credentials'].blank?
        puts "4444444444444444444444444444444444444444444444444444"
      user_tokens.build(:provider => omniauth['provider'], 
                        :uid => omniauth['uid'],
                        :token => omniauth['credentials']['token'], 
                        :secret => omniauth['credentials']['secret'])
      else
        puts "5555555555555555555555555555555555555555555555555555"
        user_tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      end
  end
                            
  def password_required?
    (new_record?) ? (user_tokens.empty?) : password.blank?
  end

end
