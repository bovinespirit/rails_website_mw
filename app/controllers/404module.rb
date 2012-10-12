
module Error404
  def rescue_action_in_public(exception)
    case exception
    when ActionController::RoutingError, ActionController::UnknownAction then
      error404
    else 
      render :text => "<html><body><h1>Application error (Rails)</h1></body></html>", :status => 500
    end
  end

  def page_unknown
    uri = Redirection.redirect(request.request_uri)
    logger.info("#{request.request_uri} -> #{uri}")
    if uri.nil?
      error404
    else
      headers["Status"] = "301 Moved Permanently"
      redirect_to uri
    end
  end
  
  def error404
    @webpage = Webpage.create("404")
    render :template => 'website/404', :layout => 'layouts/application', :status => 404
  end  

end