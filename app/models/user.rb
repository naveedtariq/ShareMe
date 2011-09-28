class User < ActiveRecord::Base

	before_validation :generate_code,     :if => lambda{ |t| t.code.blank? }
  before_create :update_name
  before_create :link_profile

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, :presence => true

  has_many :contacts, :dependent => :destroy
  has_many :associated_contacts, :class_name => "Contact", :foreign_key => :associated_user_id
  has_one :profile, :dependent => :destroy
  accepts_nested_attributes_for :profile, :allow_destroy => true


  def password_match?
    self.errors[:password] << 'password not match' if password != password_confirmation
    self.errors[:password] << 'you must provide a password' if password.blank?
    password == password_confirmation and !password.blank?
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
      self.profile.save!
    end
  end


end
