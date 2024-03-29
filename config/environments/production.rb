# Settings specified here will take precedence over those in config/environment.rb

# Force OCS to load local gems installed in home dir
ENV['GEM_PATH'] = '/home/mattwest/ruby/gems:/usr/lib/ruby/gems/1.8'
ENV['GEM_HOME'] = '/home/mattwest/ruby/gems'

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger        = SyslogLogger.new


# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false
