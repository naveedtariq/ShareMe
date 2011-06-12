class User < ActiveRecord::Base
  include OmniAuthPopulator

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :profile_attributes, :phone, :address

  has_many :user_tokens, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :associated_contacts, :class_name => "Contact", :foreign_key => :associated_user_id
  has_one :profile



  delegate :first_name, :last_name, :company,
           :to => :profile, :allow_nil => true, :prefix => :profile

  delegate :first_name=, :last_name=, :company=,
           :to => :profile, :allow_nil => true, :prefix => :profile

  attr_encrypted :name,    :key => Settings.encryption_key
  attr_encrypted :phone,   :key => Settings.encryption_key
  attr_encrypted :address, :key => Settings.encryption_key

  validates :name, :presence => true, :length => { :maximum => 250 }
  validates :code, :presence => true, :length => { :maximum => 4 }, :uniqueness => true
  validates :phone, :presence => true, :unless => lambda{ |t| t.new_record? }
  validates :address, :length => { :maximum => 250 }

  validate :uniq_phone, :unless => lambda{ |t| t.new_record? }

  before_validation :generate_password, :on => :create
  before_validation :generate_code,     :if => lambda{ |t| t.code.blank? }
  before_validation :prepare_code

  accepts_nested_attributes_for :profile, :allow_destroy => true
  after_save :update_associated_contacts

  # Check uniq phone
  #
  def uniq_phone
    errors.add(:phone, :taken) if phone.present? &&
      User.where("encrypted_phone = :p and id != :u", :p => User.encrypt(:phone, phone), :u => self.id).first
  end

  def update_associated_contacts
    associated_contacts.update_all(:name => self.name, :email => self.email)
  end

  def facebook
    user_tokens.facebook.first
  end

  # Upcase shareme code
  #
  def prepare_code
    code = code.to_s.upcase
  end

  # Generate random password
  #
  def generate_password
    @new_password, @chars = [], ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    Digest::MD5::hexdigest( [ 10.times.map{ |i| @chars[rand(@chars.size-1)] }, Time.now.to_s ].join )[0..10].each_char{|x|
      @new_password << x.send(['upcase', 'downcase'].sample)
    }
    self.password = self.password_confirmation = @new_password.join if password.blank?
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

  #
  #
  def full_name
    profile_first_name.blank? ? name : [profile_first_name, profile_last_name].join(' ')
  end

  def apply_omniauth(omniauth)
    self.omniauth = omniauth
    user_tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :omniauth => omniauth)
  end

  def password_required?
    (!persisted? && user_tokens.empty?) || password.present? || password_confirmation.present?
  end



  # Populate account from social network
  # Facebook
  #
  def populate_from_facebook(omni)
    self.name  ||= omni['user_info']['name']
    self.email ||= omni['user_info']['email']

    generate_password if self.new_record?
    generate_code if self.code.blank?
    confirm! unless self.confirmed?
    save(:validate => false)

    # Not testing this block
    #
    unless OmniAuth.config.test_mode
      begin
        self.profile || self.build_profile
        fb_user = FbGraph::User.me(omni['credentials']['token']).fetch
        profile.first_name  ||= fb_user.first_name
        profile.last_name   ||= fb_user.last_name
        self.phone          ||= fb_user.mobile_phone
        self.address        ||= fb_user.location.name
        save(:validate => false)
      rescue
      end
    end

  end


  # send all contacts notification about change code
  #
  def send_notification_about_change_code
    Notification.change_code(self, self.contacts.map(&:email)).deliver if contacts.count > 0
  end

  # Adding user to contacts
  #
  def add_contact(contact, and_add_self_to_contact = false)
    if @exists_contact = contacts.email_or_associated_user_id(contact.email, contact.id).first
      @exists_contact.update_attribute(:associated_user, contact)
    else
      @exists_contact = contacts.create({:associated_user => contact })
    end
    contact.add_contact(self) if and_add_self_to_contact
    @exists_contact
  end

  # Set flag completion registrate
  #
  def filled!
    update_attribute(:filled, true)
  end

  def connected_to?(provider)
    user_tokens.find_by_provider(provider.to_s).present?
  end

  def have_contact?(contact_or_email, type = :email)
    case type.to_s
    when 'email'
      contacts.count(:condictions => {:email => contact_or_email}) > 0
    when 'user'
      contacts.count(:condictions => {:associated_user => contact_or_email}) > 0
    else
      nil
    end
  end

  class << self

    # Simular code
    # @simular_size, integer, count of return codes
    #
    def simular_code(code, simular_size = 5)
      charset = %w( 2 3 4 6 7 9 A C D E F G H J K L M N P Q R T V W X Y Z )
      codes, count_attempts = [], 100
      while codes.size < 5 || count_attempts <= 0
        random = [code[0..2].upcase, charset.to_a[rand(charset.size)] ].flatten.join
        unless find_by_code(random)
          codes << random
          codes.uniq!
        end
      end
      return codes
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session[:omniauth]
          user.user_tokens.build(:provider => data['provider'], :uid => data['uid'])
        end
      end
    end

  end # end class << self


end


