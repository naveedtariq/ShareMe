class RemoveUserTableAndCreateDeviseUser < ActiveRecord::Migration
  def self.up
    drop_table :users
    create_table :users do |t|
      t.database_authenticatable
      t.recoverable
      t.rememberable
      t.confirmable
      t.trackable
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
