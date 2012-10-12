require 'admin/authentication_module'

# TODO: New routes and functional testing

class Admin::TagsController < ApplicationController
  include Authentication
  before_filter :authenticate, :set_webpage
  layout 'layouts/application'
  
  # GET /admin/tags
  # GET /admin/tags.xml
  def index
    @tags = Tag.counts

    respond_to do |format|
      format.html # index.rhtml
#      format.xml  { render :xml => @tags.to_xml }
    end
  end

  # GET /admin/tags/1
  # GET /admin/tags/1.xml
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
#      format.xml  { render :xml => @tags.to_xml }
    end
  end

  # GET /admin/tags/new
  def new
    @tag = Tag.new
  end

  # GET /admin/tags/1;edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /admin/tags
  # POST /admin/tags.xml
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to formatted_tag_url(@tag, :html) }
#        format.xml  { head :created, :location => tag_url(@tag) }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @tag.errors.to_xml }
      end
    end
  end

  # PUT /admin/tags/1
  # PUT /admin/tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to formatted_tag_url(@tag, :html) }
#        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#        format.xml  { render :xml => @tag.errors.to_xml }
      end
    end
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to formatted_tags_url(:format => :html) }
#      format.xml  { head :ok }
    end
  end
  
  # POST /admin/tags/untag/:id/:taggable_type/:taggable_id
  def untag
    @tag = Tag.find(params[:id])
    tagging = @tag.taggings.find_by_taggable_type_and_taggable_id(params[:taggable_type], params[:taggable_id])
    tagging.destroy unless tagging.nil?
        
    respond_to do |format|
      flash[:notice] = 'Object was successfully untagged.'
      format.html { redirect_to formatted_edit_tag_url(@tag, :html) }
#      format.xml  { head :ok }
    end    
  end

  # POST /admin/tags/tag_photo_set/:id/:photo_set
  def tag_photo_set
    @tag = Tag.find(params[:id])
    @photo_set = PhotoSet.find(params[:photo_set])
    @photo_set.tag_photos(@tag)

    respond_to do |format|
      flash[:notice] = 'Photos were successfully tagged.'
      format.html { redirect_to formatted_edit_tag_url(@tag, :html) }
#      format.xml  { head :ok }
    end    
  end

  protected
  def set_webpage
    @webpage = Webpage.create("admin/tags") unless request.xhr?
    return true
  end
end
