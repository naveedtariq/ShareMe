class AddFlnameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :f_name, :string, :null => true
    add_column :users, :l_name, :string, :null => true
  end

  def self.down
    remove_column :users, :f_name
    remove_column :users, :l_name
  end
end
