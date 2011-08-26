class Profile < ActiveRecord::Base

  belongs_to :user

  has_attached_file :picture, :styles => {:thumb => "150x150>", :contact_thumb => "108x118>", :contact_list_thumb => "30x31>"}

#TODO: call validations for the fields
  def update_profile(user)
    self.phone = user.phone
    self.company_name = user.social_profile[:company_name] if user.social_profile[:company_name]
#    save!
  end
end
