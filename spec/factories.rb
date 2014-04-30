FactoryGirl.define do
  
  Faker::Config.locale = 'en-GB'

  factory :agency do
    name "Joe Agency"
    contact "Joe Joe"
    phone "07969696969"
    email "joe@bro.com"
  end

  factory :agent, class: Agent do
    name "Joe Bro"
    mobile "07534061705"
    email "joe@bro.com"
    registration_code "fake_code"
  end

  factory :property do
    title "Joes House For Sale"
    description { "lorum ipsum " * 100 }
    price "£300,000"
    url "test_prop"
    street "231 Lavender Hill"
    postcode "SW11 1JR"
  end


# This will guess the Vistor class
  factory :visitor do

  end

  factory :agreement do
    
  end

  factory :availability do

  end

  factory :share do
    property_id 'asdfasdf'
    refer_url 'referURL.com'
  end
  
  factory :result do
    
  end
end