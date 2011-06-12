class MovePhoneToUserFromProfile < ActiveRecord::Migration
  def self.up

    add_column :users, :encrypted_phone, :string
    User.all.each {  |u| u.update_attribute(:encrypted_phone, u.profile.try(:encrypted_phone)) }
    remove_column :profiles, :encrypted_phone

  end

  def self.down

    add_column :profiles, :encrypted_phone, :string
    User.all.each { |u|
      if @profile = u.profile
        @profile.update_attribute(:encrypted_phone, u.try(:encrypted_phone))
      end
    }
    remove_column :users, :encrypted_phone

  end
end
