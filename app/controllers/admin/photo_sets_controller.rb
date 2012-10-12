require 'admin/authentication_module'

class Admin::PhotoSetsController < ApplicationController
  include Authentication
  before_filter :authenticate, :set_webpage
  layout 'layouts/application'
  
  # GET /photo_sets
  # GET /photo_sets.xml
  # formatted_photo_sets_url()
  def index
    @photo_sets = PhotoSet.find(:all, :order => 'title')
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photo_sets.to_xml }
    end
  end
  
  # GET /photo_set/1
  # GET /photo_set/1.xml
  # formatted_photo_set_url(@photo_set)
  def show
    @photo_set = PhotoSet.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
#      format.xml  { render :xml => @photo_set.to_xml }
    end
  end
  
  # GET /photo_sets/new
  # formatted_new_photo_set_url()
  def new
    @photo_set = PhotoSet.new
  end
  
  # GET /photo_sets/1;edit
  # formatted_edit_photo_set_url(photo_set)
  def edit
    @photo_set = PhotoSet.find(params[:id])
  end
  
  # POST /photo_sets
  # POST /photo_sets.xml
  def create
    @photo_set = PhotoSet.new(params[:photo_set])
    
    respond_to do |format|
      if @photo_set.save
        flash[:notice] = 'PhotoSet was successfully created.'
        format.html { redirect_to formatted_photo_set_url(@photo_set, :html) }
        format.xml  { head :created, :location => formatted_photo_set_url(@photo_set, :html) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo_set.errors.to_xml }
      end
    end
  end
  
  # PUT /photo_set/1
  # PUT /photo_set/1.xml
  def update
    @photo_set = PhotoSet.find(params[:id])
    
    respond_to do |format|
      if @photo_set.update_attributes(params[:photo_set])
        flash[:notice] = 'PhotoSet was successfully updated.'
        format.html { redirect_to formatted_photo_set_url(@photo_set, :html) }
        format.xml  { head :ok }
      else
        format.html { render formatted_edit_photo_set_url(@photo_set, :html) }
        format.xml  { render :xml => @photo_set.errors.to_xml }
      end
    end
  end
  
  # DELETE /photo_set/1
  # DELETE /photo_set/1.xml
  def destroy
    @photo_set = PhotoSet.find(params[:id])
    @photo_set.destroy
    
    respond_to do |format|
      format.html { redirect_to formatted_photo_sets_url(:format => :html) }
      format.xml  { head :ok }
    end
  end
  
  def typeselect
    if request.xhr?
      klass_name = params[:id]
      pages = Webpage.pages(klass_name)
      if pages.nil?
        render :text => "Webpages.pages(#{klass_name}) returned nil"
      else
        render :inline => "<%= select 'photo_set', 'page_id', pages, { :include_blank => true } %>",
               :locals => { :pages => pages }
      end
    else
      render :text => "Action called in error"
    end
  end
  
  # formatted_reorder_photo_set_url(photo_set, :format => :js)
  def reorder
    if request.xhr?
      photo_set = PhotoSet.find(params[:id])
      params[:photo_list].each_with_index do |phid, idx|
        pps = photo_set.photos_photo_sets.find_or_create_by_photo_id(phid)
        pps.position = idx + 1
        pps.save
      end
      render :nothing => true
    end
  end
  
  # formatted_add_photo_set_photo_set_url
  def add_photo_set
    @photo_set = PhotoSet.find(params[:id])
    @new_photo_set = PhotoSet.find(params[:photo_set_id])
    @reorder = params[:reorder]
    @photo_set.add_photo_set(@new_photo_set, @reorder)
    respond_to do |format|
      format.js # add_photo_set.rjs
      format.html { render :action => 'edit' }
      format.xml  { head :ok }
    end    
  end
  
  protected
  def set_webpage
    @webpage = Webpage.create("admin/photo_sets") if !request.xhr?
    return true
  end
end
