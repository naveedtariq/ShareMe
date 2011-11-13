class Profile < ActiveRecord::Base

  belongs_to :user

  has_attached_file :picture, :styles => {:thumb => "150x150>", :contact_thumb => "108x118>", :contact_list_thumb => "30x31>"}
  
  attr_encrypted :creditcard_number, 	  :key => Settings.encryption_key, :attribute => 'enc_creditcard_number'
  attr_encrypted :creditcard_cvv, 		  :key => Settings.encryption_key, :attribute => 'enc_creditcard_cvv'
  attr_encrypted :creditcard_holder_name, :key => Settings.encryption_key, :attribute => 'enc_creditcard_holder_name'
  attr_encrypted :creditcard_expiry, 	  :key => Settings.encryption_key, :attribute => 'enc_creditcard_expiry'
  attr_encrypted :creditcard_zip, 		  :key => Settings.encryption_key, :attribute => 'enc_creditcard_zip'
  attr_encrypted :SSN, 					  :key => Settings.encryption_key, :attribute => 'enc_SSN'
  attr_encrypted :Tin_no, 				  :key => Settings.encryption_key, :attribute => 'enc_Tin_no'
  attr_encrypted :cr_id, 				  :key => Settings.encryption_key, :attribute => 'enc_cr_id'
  attr_encrypted :passport_no, 			  :key => Settings.encryption_key, :attribute => 'enc_passport_no'
  
#TODO: call validations for the fields
  def update_profile(user)
    self.phone = user.phone
    self.company_name = user.social_profile[:company_name] if user.social_profile[:company_name]
#    save!
  end
end
