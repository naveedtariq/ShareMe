class AddFilledToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :filled, :boolean, :default => false
  end

  def self.down
    remove_column :users, :filled
  end
end
