class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string  :company_name, :null => true
      t.string  :company_address, :null => true
      t.string  :phone, :null => true
      t.string  :fax, :null => true
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
