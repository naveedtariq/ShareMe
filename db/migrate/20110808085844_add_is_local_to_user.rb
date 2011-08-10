class AddIsLocalToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_local, :boolean, :default => false
  end

  def self.down
    remove_column :users, :is_local
  end
end
