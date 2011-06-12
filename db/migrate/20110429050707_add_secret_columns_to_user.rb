class AddSecretColumnsToUser < ActiveRecord::Migration

  def self.up
    [ :name ].each {  |field|  add_column :users, :"encrypted_#{field}", :string  }
    add_column :users, :code, :string

  end

  def self.down
    [ :name  ].each {  |field|  remove_column :users, :"encrypted_#{field}"   }
    remove_column :users, :code
  end

end
