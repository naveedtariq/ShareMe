class AddPreishableTokenAndActiveToUsers < ActiveRecord::Migration
  def self.up
		add_column :users, :perishable_token,:string
		add_column :users, :active, :boolean, :default => false
  end

  def self.down
		remove_column :users, :perishable_token
		remove_column :users, :active
  end
end
