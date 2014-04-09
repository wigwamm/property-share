FactoryGirl.define do

# This will guess the User class
  factory :agent, class: Agent do
    name "John Doe"
    mobile "+447503267332"
    email "john.doe@mail.com"
    registration_code "testcode"
    type "private"
    twitter "@jdoe"
    admin false
    password "password"
    password_confirmation "password"
  end

  # factory :user, class: User do
  #   mobile "077777777777"
  # end

end