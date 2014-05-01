FactoryGirl.define do
  
  Faker::Config.locale = 'en-GB'

  factory :agent, class: Agent do
    name { Faker::Name.name }
    mobile { "07" + Faker::Number.number(9) }
    location { Faker::Address.city }
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

  factory :property do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    property_type "sale"
    price { Faker::Number.number(6) }
    price_unit "total"
    street "26 North Street"
    postcode "TA21 8LT"
    active false
  end

  factory :rental_property do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    property_type "rental"
    price { Faker::Number.number(4) }
    price_unit "per month"
    street "26 North Street"
    postcode "TA21 8LT"
    active false
  end

  factory :agreement do
    
  end

  factory :availability do
    start_time { Time.now + 10.minutes + (rand(10) * rand(10)).minutes }
    end_time { start_time + 16.minutes + (rand(10) * rand(10)).minutes }
    booked false
    created_by "tests"
  end

  factory :share do
    property_id 'asdfasdf'
    refer_url 'referURL.com'
  end
  
  factory :result do
    
  end

  factory :advanced_availability, class: Availability do
    start_time { Time.now + 1.month + (rand(10) * rand(10)).minutes }
    end_time { start_time + 16.minutes + (rand(10) * rand(10)).minutes }
    booked false
    created_by "tests"
  end

  factory :visit do
    start_time { Time.now + 10.minutes + (rand(10) * rand(10)).minutes }
    end_time { start_time + 16.minutes + (rand(10) * rand(10)).minutes }
    confirmed false
  end

  factory :image do
    title nil
    direct_upload_url "https://s3-eu-west-1.amazonaws.com/propertyshare-test/tmp/uploads/1396604841693-6gze8g7k9t6s9k9-031f25e6c835451a524469b215f272dc/1882_BTS102586_IMG_00.jpg"
    main_image false
    processed false
  end

end

