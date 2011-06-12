class MoveAddressToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :encrypted_address, :string
    remove_column :profiles, :encrypted_address
  end

  def self.down
    remove_column :users, :encrypted_address, :string
    add_column :profiles, :encrypted_address, :string
  end
end
