class AddFieldsToProfiles < ActiveRecord::Migration
  def self.up
  	change_table :profiles do |t|
	  t.string :address2, :city, :state, :zip, :country, :twitter, :facebook, :myspace, :linkedin
	  t.rename :address, :address1
	end
  end

  def self.down
  end
end
