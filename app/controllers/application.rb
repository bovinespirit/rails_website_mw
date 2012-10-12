# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require "#{RAILS_ROOT}/lib/url_filter"
require '404module'

class ApplicationController < ActionController::Base
  before_filter UrlFilter
  # Sessions are disabled most of the time
  # Individual controllers can enable them
  session :new_session => false
  include Error404
  
  protected

  # Uncomment for testing
  def local_request?
    false
  end
end