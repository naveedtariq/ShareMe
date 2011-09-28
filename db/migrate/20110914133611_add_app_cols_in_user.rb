class AddAppColsInUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :f_name, :string
    add_column :users, :l_name, :string
    add_column :users, :code, :string
    add_column :users, :phone, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :f_name
    remove_column :users, :l_name
    remove_column :users, :code
    remove_column :users, :phone
  end
end
