require 'admin/authentication_module'

module Admin
  class AdminController < ApplicationController
    include Authentication
    session :new_session => true, :only => :login
    before_filter :authenticate, :except => :login
    
    def redirect
      redirect_to comatose_root_url
    end
    
    def index
      @webpage = Webpage.create('admin')
    end
    
    def login
      @webpage = Webpage.create('admin/login')
      if request.get?
        session[:user] = nil
        @user = User.new()
      else
        @user = User.new(params[:user])
        logged_in_user = @user.try_to_login
        if logged_in_user
          session[:user] = logged_in_user
          jump_to = session[:jump_to] || { :action => 'index' }
          session[:jump_to] = nil
          redirect_to(jump_to)
        else
          flash[:notice] = 'Either the name or the password is wrong'
        end
      end
    end
    
    def logout
      session[:user] = nil
      flash[:notice] = 'Logged out'
      redirect_to login_url
    end
    
  end
end