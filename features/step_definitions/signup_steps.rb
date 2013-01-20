When /^I signup$/ do
  fill_in "user_email", :with => "newuser@example.com"
  fill_in "user_password", :with => "google123"
  fill_in "user_password_confirmation", :with => "google123"
  click_button("Sign up")
end

Then /^I should see a success message$/ do
  page.should have_selector('div.alert-success')
end

Then /^I should see a failure message$/ do
  page.should have_selector('div.alert-error')
end

Then /^I should see form errors$/ do
  page.should have_selector('div#error_explanation')
end

When /^I signup as "(.*?)"$/ do |email|
  fill_in "user_email", :with => "#{email}"
  fill_in "user_password", :with => "google123"
  fill_in "user_password_confirmation", :with => "google123"
  click_button("Sign up")
end

When /^I signup with too short of a password$/ do
  # password length requirement is 8 characters
  fill_in "user_email", :with => "newuser@example.com"
  fill_in "user_password", :with => "google"
  fill_in "user_password_confirmation", :with => "google"
  click_button("Sign up")
end

Given /^I signed up$/ do
  @user = User.create!(:email => 'original@example.com', :password => 'google123')
end

When /^I log in$/ do
  login(@user.email, @user.password)
end

When /^I log in with the wrong credentials$/ do
  login(@user.email, "wrong password")
end

When /^I request to have my password reset$/ do
  recover_password(@user.email)
end

When /^I request a new password for a non user$/ do
  recover_password("notauser@example.com")
end

When /^I reset my password$/ do
  recover_password(@user.email)
  @user.reload
  reset_password("newpassword123")
end

When /^I add a route with (\d+) location(?:|s)$/ do |route_count|
  visit new_route_path
  index = 0

  fill_in "route_name", :with => "#{route_count} routes"
  route_count.to_i.times do |i|
    fill_in "route_locations_attributes_#{index}_name", :with => "spot #{index}"
    fill_in "route_locations_attributes_#{index}_address_string", :with => "#{index+1} easy street"
    index+=1
  end
  
  click_button('Create My Route')
end

When /^I add a route without a name$/ do
  visit new_route_path
    
  fill_in "route_locations_attributes_0_name", :with => "spot 0"
  fill_in "route_locations_attributes_0_address_string", :with => "1 easy street"
  click_button('Create My Route')
end

Given /^I have (\d+) routes$/ do |route_count|
  route_count.to_i.times do |i|
    route = Route.new(:name => "foo bar #{i}", :user => @user)
    2.times{ |i| route.locations.build(:address_string => "something #{i}", :user => @user, :name => "spot #{i}") }
    route.save!
  end
end

Given /^I created an "([^"]*)" route$/ do |name|
  route = Route.new(:name => name, :user => @user)
  2.times{ |i| route.locations.build(:address_string => "something #{i}", :user => @user, :name => "spot #{i}") }
  route.save!
end

Then /^I should see a list of routes$/ do
  output = find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text } }
  data = output[0]
  data.count.should > 1
end

module LoginSteps
  def login(name, password)
    visit new_user_session_path
    fill_in "user_email", :with => name
    fill_in "user_password", :with => password
    click_button('Sign in')
  end
end

module RecoverPasswordSteps
  def recover_password(email)
    visit new_user_password_path
    fill_in 'user_email', :with => email
    click_button("Send me reset password instructions")
  end

  def reset_password(password)
    visit "#{Capybara.app_host}/users/password/edit?initial=true&reset_password_token=#{@user.reset_password_token}"
    fill_in "user_password", :with => "awesome123"
    fill_in "user_password_confirmation", :with => "awesome123"
    click_button("Change my password")
  end
end

World(LoginSteps)
World(RecoverPasswordSteps)