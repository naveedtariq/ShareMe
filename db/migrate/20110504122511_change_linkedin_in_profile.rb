class ChangeLinkedinInProfile < ActiveRecord::Migration

  def self.up
    rename_column(:profiles, :encrypted_linkedid_account,  :encrypted_linkedin_account)
    rename_column(:profiles, :encrypted_linkedid_password, :encrypted_linkedin_password)
  end

  def self.down
    rename_column(:profiles, :encrypted_linkedin_account, :encrypted_linkedid_account)
    rename_column(:profiles, :encrypted_linkedin_password, :encrypted_linkedid_password)
  end

end
