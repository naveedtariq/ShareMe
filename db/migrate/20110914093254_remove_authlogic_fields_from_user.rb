class RemoveAuthlogicFieldsFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :password_salt
    remove_column :users, :login
    remove_column :users, :failed_attempts
    remove_column :users, :last_request_at
    remove_column :users, :active
    remove_column :users, :active_token_id
  end

  def self.down
  end
end
