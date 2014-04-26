include ApplicationHelper

def valid_signin(user)
  fill_in "Mobile", with: user.mobile
  fill_in "Password", with: user.password 
  click_button "Login"
end

RSpec::Matchers.define :flash_message do |message| 
  match do |page|
    page.should have_selector('div#flash', text: message) 
  end
end