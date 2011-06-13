Factory.define(:profile) do |record|

end

Factory.define(:test_profile, :parent => :profile) do |record|
  record.phone "74394648549"
end
