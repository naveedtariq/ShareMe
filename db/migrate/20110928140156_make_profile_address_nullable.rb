class MakeProfileAddressNullable < ActiveRecord::Migration
  def self.up
    change_column :profiles, :address,:string, :null => true
  end

  def self.down
    change_column :profiles, :address,:string, :null=> false
  end
end
