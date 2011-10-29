class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.string :first_name, :null => false
      t.string :last_name
      t.string :email, :null => false
      t.string :comments, :null =>false

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
