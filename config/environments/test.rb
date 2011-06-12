Informer::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
  config.action_mailer.default_url_options = { :host => 'localhost:36488' }

end

# Test
#
#
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:facebook] = {
  'uid' => '5432',
  'user_info' => {
    'name' => 'Paxtor',
    'urls' => {
      "Facebook" => "http://www.facebook.com/profile.php?id=5432",
      "Website" => nil
    },

    "nickname"=>"profile.php?id=5432",
    "last_name"=>"Paxtor",
    "image"=>"http://graph.facebook.com/5432/picture?type=square",
    "email"=>"paxtor@gmail.com",
    "first_name"=>"Maxim" },

  "provider"=>"facebook",
  'credentials' => {
    'token' => 'YDW::::::FSKKKFS'
  }

}
