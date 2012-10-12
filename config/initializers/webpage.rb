# Load webpage subclasses
require 'webpage'
Dir[File.join(RAILS_ROOT, 'app', 'webpage_types', '*.rb')].each do |path|
  require "#{path}"
end

