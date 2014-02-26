source "https://rubygems.org"

gem "rails", "4.0.0"
gem "turbolinks"
gem "jbuilder", "~> 1.2"
gem "bcrypt-ruby", :require => "bcrypt"
gem "mongoid", git: "git://github.com/mongoid/mongoid.git"
gem "bson_ext"

gem "sass-rails", "~> 4.0.0"
gem "compass-rails", "~> 1.1.2"
gem "oily_png"
gem "breakpoint"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"
gem "jquery-ui-rails"
gem 'jquery-turbolinks'
gem "slim-rails"
gem "activesupport"
gem 'newrelic_rpm'

group :development do
  gem "pry"
  gem "nifty-generators"
end

group :test do
  gem "growl", "~> 1.0.3"
  gem "rb-fsevent", "~> 0.9.4"
  gem "spork-rails"
  gem "guard-rails"
  gem "guard-spork"
  gem "guard-rspec", require: false
  gem "rspec-rails"
  gem "cucumber-rails", require: false
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara"
  gem "mocha"
end

group :production do
  gem 'rails_12factor'
end

####################
### => Server/Deployment Gems

gem "unicorn"

# Use Capistrano for deployment
# gem "capistrano", group: :development
# Use debugger
# gem "debugger", group: [:development, :test]

####################
### => Application Gems

gem "devise", "~> 3.2.2"
gem "twilio-ruby", "~> 3.11.5"
gem "geocoder", "~> 1.1.9"
gem "stalker", "~> 0.9.0"
gem "delayed_job_mongoid", :git => "https://github.com/collectiveidea/delayed_job_mongoid.git"
gem "mongoid-paperclip", :require => "mongoid_paperclip"
gem "aws-sdk", "~> 1.34.1"
