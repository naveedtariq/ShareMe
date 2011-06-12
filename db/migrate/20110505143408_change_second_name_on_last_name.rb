class ChangeSecondNameOnLastName < ActiveRecord::Migration
  def self.up
    rename_column :profiles, :encrypted_second_name, :encrypted_last_name
  end


  def self.down
    rename_column :profiles, :encrypted_last_name, :encrypted_second_name
  end
end
