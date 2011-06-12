class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id

      [ :first_name, :second_name, :phone, :company, :address,
        :google_account,   :google_password,
        :facebook_account, :facebook_password,
        :twitter_account,  :twitter_password,
        :skype_account,    :skype_password,
        :linkedid_account, :linkedid_password
      ].each {  |field|  t.string :"encrypted_#{field}" }

      t.timestamps
    end
    add_index :profiles, :user_id

  end

  def self.down
    drop_table :profiles
  end
end
