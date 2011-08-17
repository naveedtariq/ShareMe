class Contact < ActiveRecord::Base
  belongs_to :user
  belongs_to :associated_user, :class_name => "User"

  scope :email_or_associated_user_id, lambda{ |email, user_id|
    where("associated_user_id = :user_id or email = :email", {:user_id => user_id, :email => email})
  }

  validates :name, :email, :presence => true, :length => { :maximum => 250 }

  before_validation :prepare_data

  def prepare_data
    unless associated_user.blank?
      self.name  = associated_user.name  if self.name.blank?
      self.email = associated_user.email if self.email.blank?
    end
  end

  def self.add_contact(user, options)
    puts options.inspect + "oooooooooooooooooooooooooooooooooooooooooooooooooooooo"
    @email, @name = options[:email], options[:name]
    return user if @email == user.email
    @skip_invitation = !!options[:skip_invitation]
    if @email.present? && @name.present?
      unless ( @associated_user = user.contacts.find_by_email(@email).try(:associated_user) )
        @associated_user = User.find_by_email(@email) #|| User.invite!(:email => @email, :name => @name) {  |u| u.skip_invitation = @skip_invitation }
        user.contacts.create(:email => @email,  :name => @name, :associated_user => @associated_user)
      end
      return @associated_user
    else
      nil
    end
  end
end
