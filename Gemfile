source 'https://rubygems.org'

gem 'rails', '4.1.0'
gem 'rails-i18n', '~> 4.0.0'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'bson_ext'
gem 'activesupport'
gem 'protected_attributes'

gem 'compass-rails', '~> 1.1.2'
gem 'sass-rails', '~> 4.0.0'
gem 'breakpoint'
gem 'oily_png'
gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'coffee-rails', '~> 4.0.0'
gem 'slim-rails'
gem 'pry'

group :development do
  gem 'spring', group: :development
  gem 'nifty-generators'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.14.2'
end

group :test do
  gem 'spring-commands-rspec', '~> 1.0.1'
  gem 'guard-rspec', '~> 4.2.8'
  gem 'faker', '~> 1.3.0'
  gem "nyan-cat-formatter"
  gem 'database_cleaner', '~> 1.2.0'
  gem 'launchy'  # gem 'resque_spec'
  
  gem 'mongoid-rspec'

  gem 'growl', '~> 1.0.3'
  gem 'rb-fsevent', '~> 0.9.4'

  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'capybara', '~> 2.2.1'
  # gem 'mocha', '~> 1.0.0'
end

group :production do
  gem 'rails_12factor'
end

####################
### => Server/Deployment Gems

# gem 'thin'
gem 'unicorn'

####################
### => Analytics Gems

gem 'newrelic_rpm'
gem 'le'

####################
### => User Testing

# info for implementing split
# https://github.com/andrew/split
# http://davidtuite.com/posts/a-b-testing-with-split-in-ruby-on-rails

# gem 'split', '~> 0.7.1'


####################
### => Application Gems

gem 'simple_form'

gem 'devise', '~> 3.2.2'
# use to send devise emails in the background
gem 'devise-async', '~> 0.9.0'

gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

gem 'twilio-ruby', '~> 3.11.5'
gem 'geocoder', '~> 1.1.9'

gem 'mongoid-paperclip', :require => 'mongoid_paperclip'
gem 'aws-sdk', '~> 1.34.1'
gem 's3_direct_upload'

gem 'mongoid_token', git: 'git://github.com/thetron/mongoid_token.git', branch: 'update/mongoid-4'

gem "resque", "~> 1.25.1"
gem 'redis', '~> 3.0.7'
gem "resque-scheduler", "~> 2.5.4"
gem 'resque-web', git: 'git://github.com/resque/resque-web', require: 'resque_web'

# gem 'hirefire-resource'

gem 'bitly', '~> 0.10.1'


