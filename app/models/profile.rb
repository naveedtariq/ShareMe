class Profile < ActiveRecord::Base

  belongs_to :user

#TODO: call validations for the fields
  def update_profile(user)
    self.phone = user.phone
    save!
  end
end
