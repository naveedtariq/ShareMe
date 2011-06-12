
Given /^the user "([^\"]*)" has following contacts:$/ do |user_email, table|
  @user = User.find_by_email(user_email)
  table.hashes.each do |row|
    @contact = User.find_by_email(row["email"]) || Factory(:test_user, row)
    @user.add_contact(@contact)
  end
end


Then /^contact "([^\"]*)" should be added to "([^\"]*)" contacts$/ do |assigned_user_email, user_email|
  @user = User.find_by_email(user_email)
  @user.contacts.find_by_email(assigned_user_email).should be_present
end


Then /^I should see my data:$/ do |table|
  table.rows.each do |t|
    Then %Q(I should see "#{t.first}")
    And %Q(I should see "#{t.last}")
  end
end


Given /^there is a user "([^\"]*)" with attributes:$/ do |email, attrs_table|
  @user = User.find_by_email(email) || Factory(:test_user, :email => email)
  @profile_attrs =  Hash[*attrs_table.rows_hash.select{|k,v| k =~ /^profile/ }.map{ |v|
                           [v.first.split('profile_').last, v.last]
                         }.flatten ]
  @user_attrs    =  Hash[*attrs_table.rows_hash.select{|k,v| k !~ /^profile/ }.flatten]
  @user.update_attributes(@user_attrs)
  unless @profile_attrs.blank?
    @profile = (@user.profile || @user.build_profile)
    @profile.attributes = @profile_attrs
    @profile.save
  end
  @user.update_attribute(:code, @user_attrs["code"]) if @user_attrs.has_key?("code")
end

Given /^the following users exist:$/ do |users_table|
  users_table.hashes.each do |hash|
    if hash.has_key?("email") && ( @user = User.find_by_email(hash["email"]))
      @user.update_attributes(hash)
    else
      @user = Factory(:test_user, hash)
    end
     @user.update_attribute(:code, hash["code"]) if hash.has_key?("code")
  end
end

Given /^user "([^\"]*)" has the following contacts:$/ do |email, table|
  @user = User.find_by_email(email) || Factory(:user, :email => email)
  table.hashes.each do |t|
    @user.contacts << Factory.build(:test_contact, t)
  end
end

Given /^ShareMe code "([^\"]*)" does not exist yet$/ do |code|
  User.find_by_code(code).try(:destroy)
end


Then /^I should see "([^\"]*)" code variants that start with \/([^\/]*)\/$/ do |count_variants, start_with_code|
  count_variants = count_variants.to_i
  reg =   regexp = Regexp.new(start_with_code)
  all('a', :text => reg).count.should == count_variants
end

Given /^ShareMe code "([^\"]*)" already exists$/ do |code|
  Factory(:test_user).update_attribute(:code, code)
  # User.stub!(:find_by_code).with(code).and_return(mock(User, { :code => code}))
end


Given /^I sign in as "([^\"]*)"$/ do |email_password|
  @email, @password =  email_password.split('/')
  When %Q(I go to the login page)
  And %Q(I fill in "Email" with "#{@email}")
  And %Q(I fill in "Password" with "#{@password}")
  And %Q(I press "Sign In")
end

Given /^I am signed up as "([^\"]*)" with name "([^\"]*)"$/ do |email_password, user_name|
  @email, @password = email_password.split('/')
  @user = Factory(:user, { :filled => true, :email => @email, :name => user_name, :password => @password, :password_confirmation => @password})
  @user.confirm!
end


When /^I should see link Sign up via Facebook$/ do
  all('a', :title => "Sign up via Facebook").should(be_present)
end

Then /^I should see link Sign in via Facebook$/ do
  all('a', :title => "Sign in via Facebook").should(be_present)
end

Then /^I should see link "([^\"]*)"$/ do |link_text|
  all('a', :text => link_text).should be_present
end


Then /^I should see the following links:$/ do |table|
  table.rows.each do |r|
    all('a', :text => r.to_s).should be_present
  end
end

Then /^I should be signed in$/ do
  all('a', :text => 'Sign In').should be_blank
end

Then /^I should not be signed in$/ do
  When %Q(I go to the dashboard root page)
  Then %Q(I should see "You need to sign in or sign up before continuing.")
end

Then /^I should see error messages:$/ do |table|
  table.hashes.each do |msg|
    Then %Q(I should see "#{msg['message']}")
  end
end

