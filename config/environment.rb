# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Propertyshareio::Application.initialize!

unless Rails.env.development?
  Rails.logger = Le.new('63521001-2a15-472d-b482-2570a0c9dac9')
end