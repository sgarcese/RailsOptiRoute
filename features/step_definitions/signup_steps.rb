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

module LoginSteps
  def login(name, password)
    visit new_user_session_path
    fill_in "user_email", :with => name
    fill_in "user_password", :with => password
    click_button('Sign in')
  end
end

World(LoginSteps)