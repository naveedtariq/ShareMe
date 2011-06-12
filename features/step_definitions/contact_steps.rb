Then /^I should see the following contacts:$/ do |table|
  table.hashes.each do |r|
    Then %Q(I should see "#{r["name"]}")
    And %Q(I should see "#{r["email"]}")
  end
end
