# Load liquid bits
Dir[File.join(RAILS_ROOT, 'app', 'liquid', '*.rb')].each do |path|
  require "#{path}"
end

