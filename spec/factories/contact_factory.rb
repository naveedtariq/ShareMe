Factory.define(:contact) do |record|

end

Factory.define(:test_contact, :parent => :contact) do |record|
  record.name "TestUser"
  record.email "test@gmail.com"
end
