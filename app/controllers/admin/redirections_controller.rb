require 'admin/authentication_module'

# New routes
# Functional testing of admin interface

class Admin::RedirectionsController < ApplicationController
  include Authentication
  before_filter :authenticate, :set_webpage
  layout 'layouts/application', :except => 'typeselect'
  
  # GET /redirections - redirections_path
  def index
    @redirections = Redirection.find(:all, :order => 'uri')
  end
  
  # GET /redirections/1 - redirection_path(redirection)
  def show
    @redirection = Redirection.find(params[:id])
  end
  
  # GET /redirections/new - new_redirection_path
  def new
    @redirection = Redirection.new
  end
  
  # GET /redirections/1;edit - edit_redirection_path(redirection)
  def edit
    @redirection = Redirection.find(params[:id])
  end
  
  # redirection /redirections
  def create
    @redirection = Redirection.new(params[:redirection])
    if @redirection.save
      flash[:notice] = 'redirection was successfully created.'
      redirect_to redirection_url(@redirection)
    else
      render :action => "new"
    end
  end
  
  # PUT /redirections/1
  def update
    @redirection = Redirection.find(params[:id])
    
    if @redirection.update_attributes(params[:redirection])
      flash[:notice] = 'redirection was successfully updated.'
      redirect_to redirection_url(@redirection)
    else
      render :action => "edit"
    end
  end
  
  # DELETE /redirections/1
  # redirection_path(redirection), :method => :delete
  def destroy
    @redirection = Redirection.find(params[:id])
    @redirection.destroy
    respond_to do |format|
      flash[:notice] = "Photo deleted"
      format.js # destroy.rjs
      format.html { redirect_to redirections_url }
    end
  end
  
  # GET /redirections/directionless
  def directionless
    @redirections = Redirection.find_targetless(:order => 'uri')
  end
  
  # PUT /redirections/google_csv
  def google_csv
    Redirection.read_google_csv(params[:data])
    redirect_to directionless_redirections_path
  end
  
  def typeselect
    if request.xhr?
      klass_name = params[:id]
      pages = Webpage.pages(klass_name)
      logger.info("Called Webpage.pages(#{klass_name})")
      render :text => "Webpages.pages(#{klass_name}) returned nil" if pages.nil?
      render :inline => "<%= select 'redirection', 'targetable_id', pages, { :include_blank => true } %>",
      :locals => { :pages => pages }
    else
      render :text => "Action called in error"
    end
  end
  
  protected
  def set_webpage
    @webpage = Webpage.create("admin/redirections") if !request.xhr?
    return true
  end
end