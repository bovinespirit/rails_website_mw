require 'admin/authentication_module'

class Admin::PhotosController < ApplicationController
  # TODO: AJAX Filtering of index page?
  # TODO: Cache rhtml and rjs pages
  include Authentication
  before_filter :authenticate, :set_webpage
  layout 'layouts/application', :except => [:preview_text]
  cache_sweeper :photo_sweeper, :only => [:destroy, :create, :update]
  helper :photo
  
  # GET /admin/photos
  # GET /admin/photos.xml
  # formatted_photos_url()
  def index
    @photos = Photo.find(:all, :order => 'title')
    respond_to do |format|
      format.html # index.rhtml
#      format.xml  { render :xml => @photos.to_xml }
    end
  end
  
  # GET /admin/photos/1
  # GET /admin/photos/1.xml
  # formatted_photo_url(@photo)
  # Uses photo/_photo partial to display, thus showing what the punter will see...
  def show
    @photo = Photo.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
#      format.xml  { render :xml => @photo.to_xml }
    end
  end
  
  # GET /admin/photos/new
  # GET /admin/photo_sets/1/photos/new
  # formatted_new_ps_photo_url(@photo_set)
  def new
    @photo = Photo.new()
    @photo_set_id = params.has_key?(:photo_set_id) ? PhotoSet.find(params[:photo_set_id]).id : 0
    headers["Content-Type"] = 'text/html'
  end
  
  # GET /admin/photos/1;edit
  def edit
    @photo = Photo.find(params[:id])
    headers["Content-Type"] = 'text/html'
  end
  
  # POST /admin/photos
  # POST /admin/photos.xml
  # POST formatted_photos_url
  def create
    data = params[:photo].delete(:data)
    @photo = Photo.new(params[:photo])
    if @photo.save
      @photo.data = data
      @photo.alter_photo_sets(params[:photo_sets]) if params.has_key?(:photo_sets)
    end
    respond_to do |format|
      if @photo.save
        flash[:notice] = "Photo successfully created"
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :created, :location => formatted_photo_url(@photo, :html) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end
  
  # PUT /admin/photos/1
  # PUT /admin/photos/1.xml
  def update
    @photo = Photo.find(params[:id])
    @photo.attributes = params[:photo]
    @photo.thumb_x = params[:x1] if params[:x1]
    @photo.thumb_y = params[:y1] if params[:y1]
    @photo.thumb_l = (@photo.thumb_vertical) ? params[:height] : params[:width] if params[:height] and params[:width]
    
    @photo.alter_photo_sets(params[:photo_sets]) if params.has_key?(:photo_sets)
    
    respond_to do |format|     
      if @photo.save
        flash[:notice] = "Photo successfully updated"
        format.html { redirect_to formatted_photo_url(@photo, :html) }
        format.xml  { head :ok }           
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end
  
  # DELETE /admin/photos/1
  # DELETE /admin/photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    
    respond_to do |format|
      flash[:notice] = "Photo deleted"
      format.html { redirect_to formatted_photos_url(:format => :html) }
      format.js # destroy.rjs
      format.xml { head :ok }
    end
  end
  
  # admin/photos/1;edit_thumbnail
  # formatted_edit_thumbnail_photo_url(photo)
  def edit_thumbnail
    @photo = Photo.find(params[:id])
    headers["Content-Type"] = 'text/html'
  end
  
  # /admin/photos/1;swap_vertical
  # formatted_swap_vertical_url(photo)
  def swap_vertical
    @photo = Photo.find(params[:id])
    @photo.thumb_vertical = !@photo.thumb_vertical
    respond_to do |format|
      if @photo.save
        flash[:notice] = "Swapped orientation"
        format.html { redirect_to formatted_edit_thumbnail_photo_url(@photo, :format => :html) }
#        format.xml { head :ok }
      else
        format.html { redirect_to formatted_edit_thumbnail_photo_url(@photo, :format => :html) }
#        format.xml { render :xml => @photo.errors.to_xml }
      end
    end
  end
  
  # /admin/photos;preview_text
  # formatted_preview_text_photos_url
  def preview_text
    render :nothing => true unless params[:photo]
  end
  
  # /admin/photo_sets/1/photos/1;move_up
  # formatted_move_up_ps_photo(photo_set, photo)
  def move_up
    @photo_set = PhotoSet.find(params[:photo_set_id])
    @photo = @photo_set.photos.find(params[:id])
    @photo.move_up(@photo_set)
    
    respond_to do |format|
      format.html { redirect_to formatted_edit_photo_set_url(@photo_set, :format => :html) }
#      format.xml { render :xml => @photo_set.to_xml }
    end
  end
  
  # /admin/photo_sets/1/photos/1;move_down
  # /admin/photo_sets/1/photos/1.xml;move_down
  # formatted_move_down_ps_photo_url(photo_set, photo)
  def move_down
    @photo_set = PhotoSet.find(params[:photo_set_id])
    @photo = @photo_set.photos.find(params[:id])
    @photo.move_down(@photo_set)
    
    respond_to do |format|
      format.html { redirect_to formatted_edit_photo_set_url(@photo_set, :format => :html) }
#      format.xml { render :xml => @photo_set.to_xml }
    end
    
  end
  
  # /admin/photo_sets/1/photos/1;remove
  # ps_remove_photo_url(@photo_set, @photo)
  # formatted_remove_ps_photo_url
  def remove
    @photo_set = PhotoSet.find(params[:photo_set_id])
    @photo = @photo_set.photos.find(params[:id])
    @photo.remove_from(@photo_set)
    
    respond_to do |format|
      flash[:notice] = 'Photo removed'
      format.html { redirect_to formatted_edit_photo_set_url(@photo_set, :format => :html) }
      format.js { } # remove.rjs
      format.xml { render :xml => @photo_set.to_xml }
    end
  end
  
  # /admin/photo_sets/1/photos/1;add
  # /admin/photo_sets/1/photos/1.js;add
  # formatted_add_ps_photo(photo_set, photo)
  def add
    @photo_set = PhotoSet.find(params[:photo_set_id])
    @photo = Photo.find(params[:id])
    
    respond_to do |format|
      if @photo_set.add_photo(@photo)
        flash[:notice] = 'Photo Added'
        format.html { redirect_to formatted_edit_photo_set_url(@photo_set, :html) }
        format.js { } # add.rjs
        format.xml { render :xml => @photo_set.to_xml }
      else
        format.html { redirect_to formatted_edit_photo_set_url(@photo_set, :html) }
        format.js do
          render :update do |page|
            page.alert("Error : #{@photo_set.errors.full_messages.join(', ')}")
          end
        end
        format.xml { render :xml => @photo_set.errors.to_xml }
      end
    end
  end      
  
  protected
  def set_webpage
    @webpage = Webpage.create("admin/photos") if !request.xhr?
    return true
  end
end
