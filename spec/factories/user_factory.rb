Factory.sequence :phone_seq do |n|
  "2222222#{n}"
end

Factory.define(:user) do |record|

end

Factory.define(:test_user, :parent => :user) do |record|
  record.name "TestUser"
  record.email "test@gmail.com"
  record.password "testttt"
  record.password_confirmation "testttt"
  record.phone Factory(:phone_seq)
end
