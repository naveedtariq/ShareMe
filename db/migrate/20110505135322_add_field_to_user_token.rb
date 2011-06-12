class AddFieldToUserToken < ActiveRecord::Migration
  def self.up
    add_column :user_tokens, :token, :string
    add_column :user_tokens, :secret, :string
    add_column :user_tokens, :nickname, :string
  end

  def self.down
    remove_column :user_tokens, :nickname
    remove_column :user_tokens, :secret
    remove_column :user_tokens, :token
  end
end
