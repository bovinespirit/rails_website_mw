class UrlFilter
  def self.filter(controller)
    opts = {}
    opts[:host] = controller.request.host
    opts[:port] = controller.request.port if controller.request.port != controller.request.standard_port
#    opts[:controller] = controller.params[:controller]
#    opts[:action] = controller.params[:action]
    ActionController::UrlWriter::default_url_options = opts
  end
end