# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

if ENV['RAILS_ENV'] == 'production'
  # Force OCS to load local gems installed in home dir
  ENV['GEM_PATH'] = '/home/mattwest/ruby/gems:/usr/lib/ruby/gems/1.8'
  ENV['GEM_HOME'] = '/home/mattwest/ruby/gems'
end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
config.frameworks -= [ :action_web_service, :action_mailer ]

config.plugins = [:all ]
  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
config.action_controller.cache_store = :file_store, "#{RAILS_ROOT}/public/cache"

config.time_zone = 'UTC'
  # Make Active Record use UTC-base instead of local time
config.active_record.default_timezone = :utc
config.active_record.observers = :title_observer
  # Use Active Record's schema dumper instead of SQL when creating the test database
  # (enables use of different database adapters for development and test environments)
  # config.active_record.schema_format = :ruby

  # See Rails::Configuration for more options
end

ActionController::Base.page_cache_directory = "#{RAILS_ROOT}/public"
# ActionController::Base.page_cache_extension = ".cache"

# Logging colours off
ActiveRecord::Base.colorize_logging = false

# Set cookies key to prevent conflicts
ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS[:session_key] = 'mfwapp_session_id'

LastfmChart.lastlog = Logger.new("#{RAILS_ROOT}/log/lastfm.log")

require "date_time_formats"

