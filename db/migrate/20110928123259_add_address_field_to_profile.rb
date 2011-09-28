class AddAddressFieldToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :address, :string, :null=>false
  end

  def self.down
    remove_column :profiles, :address
  end
end
