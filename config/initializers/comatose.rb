
require '404module'
require 'admin/authentication_module'
Comatose.configure do |config|
  config.disable_caching = true
  config.default_processor = :liquid
  config.includes << Error404
  config.admin_includes << Error404
  config.admin_includes << Authentication 
  config.helpers << :application_helper
  config.helpers << ActionView::Helpers::AssetTagHelper
  config.admin_helpers << :application_helper
  config.admin_authorization = :authenticate
  config.after_setup = Proc.new { require 'comatose/comatose_ex' }
end

