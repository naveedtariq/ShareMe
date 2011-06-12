# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Informer::Application.initialize!
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
