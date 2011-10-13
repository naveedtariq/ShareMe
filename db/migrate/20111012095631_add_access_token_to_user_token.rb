class AddAccessTokenToUserToken < ActiveRecord::Migration
  def self.up
    add_column :user_tokens, :token, :string
  end

  def self.down
    remove_column :user_tokens, :token
  end
end
