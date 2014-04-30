FactoryGirl.define do
  
  Faker::Config.locale = 'en-GB'

  factory :agent, class: Agent do
    # You'll need to update this
    name: "Joe Bro"
    mobile "07777777777"

    # name { Faker::Name.name }
    # mobile { "07" + Faker::Number.number(9) }
    # email { Faker::Internet.email }
    # registration_code "testcode"
    # type "private"
    # twitter { Faker::Name.name }
    # admin false
    # @password = Faker::Internet.password(min_length = 8)
    # password @password
    # password_confirmation @password
  end

# This will guess the Vistor class
  factory :visitor do
    name { Faker::Name.name }
    mobile { "07" + Faker::Number.number(9) }
  end

  factory :agreement do
    
  end

  factory :availability do
    start_time { Time.now + 10 + (rand(100) * rand(100)).minutes }
    end_time { start_time + (rand(100) * rand(100)).minutes }
    booked false
    created_by "tests"
  end

  factory :share do
    property_id 'asdfasdf'
    refer_url 'referURL.com'
  end
  
  factory :result do
    
  end
end