class Profile < ActiveRecord::Base

  belongs_to :user

#TODO: call validations for the fields
  def update_profile(user)
    self.phone = user.phone
    self.company_name = user.social_profile[:company_name] if user.social_profile[:company_name]
#    save!
  end
end
