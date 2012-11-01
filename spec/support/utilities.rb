include ApplicationHelper

def valid_signin(sample_user)
  fill_in "Email",    with: sample_user.email
  fill_in "Password", with: sample_user.password
  click_button "Sign In"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

def sign_in(sample_user)
  visit signin_path
  fill_in "Email",    with: sample_user.email
  fill_in "Password", with: sample_user.password
  click_button "Sign In"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = sample_user.remember_token
end