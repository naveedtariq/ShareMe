class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :user_id, :null => false
      t.string  :name,    :null => false
      t.string  :email,   :null => false

      t.integer :associated_user_id  # пользователь котоый связан с этим контактом
      t.timestamps
    end

    add_index :contacts, :user_id
    add_index :contacts, :email
    add_index :contacts, :associated_user_id
  end

  def self.down
    drop_table :contacts
    remove_index :contacts, :user_id
    remove_index :contacts, :email

  end
end
