class AddSearchedCodeToUser < ActiveRecord::Migration
  def self.up
		add_column :users, :searched_code, :string
  end

  def self.down
		remove_column :users, :searched_code
  end
end
