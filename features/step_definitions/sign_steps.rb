When /^I delete the (\d+)(?:st|nd|rd|th) sign_up$/ do |pos|
  visit sign_ups_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following sign_ups:$/ do |expected_sign_ups_table|
  expected_sign_ups_table.diff!(tableish('table tr', 'td,th'))
end
