class UpdateUserPhoneColType < ActiveRecord::Migration
  def self.up
    change_column :users, :phone, :string, :null => true
  end

  def self.down
    change_column :users, :phone, :integer, :null => true
  end
end
