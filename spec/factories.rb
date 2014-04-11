FactoryGirl.define do

  Faker::Config.locale = 'en-GB'

  factory :agent, class: Agent do
    name { Faker::Name.name }
    mobile { "07" + Faker::Number.number(9) }
    email { Faker::Internet.email }
    registration_code "testcode"
    type "private"
    twitter { Faker::Name.name }
    admin false
    @password = Faker::Internet.password(min_length = 8)
    password @password
    password_confirmation @password
  end

# This will guess the Vistor class
  factory :visitor do
    name { Faker::Name.name }
    mobile { "07" + Faker::Number.number(9) }
  end

  factory :agreement do
    
  end
end

