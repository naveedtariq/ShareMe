class AddFirstTimeSigninFromFacebook < ActiveRecord::Migration
  def self.up
    add_column :users, :first_signin_fb, :boolean, :default=>:false
  end

  def self.down
    remove_column :users, :first_signin_fb
  end
end
