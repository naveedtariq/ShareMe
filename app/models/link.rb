class Link < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact, :class=>"User", :foreign_key => "contact_id"

 
end
