class Profile < ActiveRecord::Base
  belongs_to :user
  [ :first_name, :last_name, :company,
    :google_account,   :google_password,
    :facebook_account, :facebook_password,
    :twitter_account,  :twitter_password,
    :skype_account,    :skype_password,
    :linkedin_account, :linkedin_password
  ].each { |f|  attr_encrypted f, :key => Settings.encryption_key  }

  validates :first_name, :last_name, :company,
            :google_account,   :google_password, :facebook_account, :facebook_password,
            :twitter_account,  :twitter_password, :skype_account,    :skype_password,
            :linkedin_account, :linkedin_password, :length => { :maximum => 150 }
end
