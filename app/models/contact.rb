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

  def update_email_and_name
    if associated_user
      self.name = associated_user.name   unless self.name  == associated_user.name
      self.email = associated_user.email unless self.email == associated_user.email
      save
    end
  end

  class << self
    def add_contact(user, options)
      @email, @name = options[:email], options[:name]
      return user if @email == user.email
      @skip_invitation = !!options[:skip_invitation]
      if @email.present? && @name.present? && @email.match(Devise.email_regexp)

        unless ( @associated_user = user.contacts.find_by_email(@email).try(:associated_user) )
          @associated_user = User.find_by_email(@email) ||
            User.invite!(:email => @email, :name => @name) {  |u| u.skip_invitation = @skip_invitation }
          user.contacts.create(:email => @email,  :name => @name, :associated_user => @associated_user)
        end

        return @associated_user

      else
        nil
      end
    end

    def import_from_xls(user, path_file)

      Spreadsheet.open(path_file) do |book|
        @worksheet = book.worksheets[0]
        @header = @worksheet.row(0).to_a

        @email_index = @header.index("email") || 0
        @name_index  = @header.index("name")  || 1

        @worksheet.each( @header.include?("email") ? 1 : 0) do |row|
          @email = row.to_a[@email_index].to_s.strip rescue nil
          @name  = row.to_a[@name_index].to_s.strip  rescue nil
          add_contact(user, { :email => @email, :name => @name})
        end

      end
    end

  end # end class << self

end
