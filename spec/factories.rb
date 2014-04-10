FactoryGirl.define do

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


# This will guess the Vistor class
  factory :visitor do
    mobile "077777777777"
    name "Luke"
  end

end

