class AddFieldsToProfiles < ActiveRecord::Migration
  def self.up
  	change_table :profiles do |t|
	  t.string :address2, :city, :state, :zip, :country, :twitter, :facebook, :myspace, :linkedin, 
	           :enc_creditcard_number, :enc_creditcard_cvv, :enc_creditcard_holder_name, :enc_creditcard_expiry, :enc_creditcard_zip, :paypal_email_id,
	           :enc_SSN, :enc_Tin_no, :enc_cr_id, :enc_passport_no
	           
	  t.rename :address, :address1
	end
	remove_column :profiles, :company_address
  end

  def self.down
  	remove_column	:profiles, :address2
  	remove_column	:profiles, :city
  	remove_column	:profiles, :state
  	remove_column	:profiles, :zip
  	remove_column	:profiles, :country
  	remove_column	:profiles, :twitter
  	remove_column	:profiles, :facebook	
  	remove_column	:profiles, :myspace
  	remove_column	:profiles, :linkedin
  	remove_column	:profiles, :enc_creditcard_number
  	remove_column	:profiles, :enc_creditcard_cvv
  	remove_column	:profiles, :enc_creditcard_holder_name
  	remove_column	:profiles, :enc_creditcard_expiry
  	remove_column	:profiles, :enc_creditcard_zip
  	remove_column	:profiles, :paypal_email_id
  	remove_column	:profiles, :enc_SSN
  	remove_column	:profiles, :enc_Tin_no
  	remove_column	:profiles, :enc_cr_id
  	remove_column	:profiles, :enc_passport_no
	
	change_table :profiles do |t|			
		t.rename :address1, :address
		t.string :company_address
	end
  end
end
