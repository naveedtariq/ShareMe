class AddSecretToUserToken < ActiveRecord::Migration
  def self.up
    add_column :user_tokens, :secret, :string
  end

  def self.down
    remove_column :user_tokens, :secret
  end
end
