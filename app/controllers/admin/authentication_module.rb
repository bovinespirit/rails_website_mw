
# Block unauthorised users...
module Authentication
  def authenticate
    unless session[:user]
      flash[:notice] = 'Please log in'
      session[:jump_to] = request.request_uri
      redirect_to login_url
    end
  end
  
end