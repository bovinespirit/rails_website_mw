
class PhotoController < ApplicationController
  # TODO: Better caching of rhtml and rjs pages
  before_filter :strip_size, :only => [:img, :imgbg]
  before_filter :find_photo, :except => ['rescue_action_in_public']
  caches_page :img, :imgbg
  
  def img
    @size = nil if @size == 'main'
    send_data(@photo.resize_thumb(@size), :type => 'image/jpeg', :disposition => 'inline')
  end

  def imgbg
    send_data(@photo.make_bg(@size), :type => 'image/jpeg', :disposition => 'inline') if @photo
  end
  
  # Redirects old addresses
  def show
  end
  
  def set
  end
  
  def carousel
    @dir = (params[:dir] == 'prev.js')? :prev : :next
    begin
      throw if (@photo.nil? or @photo_set.nil?)
      @current_photo = Photo.find(params[:current])
      respond_to do |format|
        format.html { throw }
        format.js # carousel.rjs
      end
    rescue
      render :action => 'error', :status => 404
    end
  end
  
  def rescue_action_in_public(exception)
    render :action => 'error', :status => 404
  end
  
  def local_request?
    false
  end
  
  protected
  def find_photo
    @photo = @photo_set = nil
    begin
      if params.has_key?(:photo_set)
        @photo_set = PhotoSet.find(params[:photo_set])
        @photo = @photo_set.photos.find(params[:photo]) if !@photo_set.nil? and params.has_key?(:photo)
      else
        @photo = Photo.find(params[:photo]) if params.has_key?(:photo)        
      end
    rescue
      @photo = Photo.find_by_slug(params[:photo])
      if @photo
        headers["Status"] = "301 Moved Permanently"      
        redirect_to photonoset_url(:photo => @photo)
      else
        render :action => 'error', :status => 404
      end
      return false
    end
  end
  
  # Filenames for caching are like 'small.jpg'
  def strip_size
    @size = params[:size] || nil
    @size = @size.split('.')[0] if !@size.nil?
  end
end
