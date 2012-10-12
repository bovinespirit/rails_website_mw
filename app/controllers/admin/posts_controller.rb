require 'admin/authentication_module'

# New routes and functional testing

class Admin::PostsController < ApplicationController
  include Authentication
  before_filter :authenticate, :set_webpage
  layout 'layouts/application'
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.find(:all, :order => :created_at)

    respond_to do |format|
      format.html # index.rhtml
#      format.xml  { render :xml => @posts.to_xml }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
#      format.xml  { render :xml => @post.to_xml }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new(:staging => true)
  end

  # GET /posts/1;edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to post_url(@post) }
#        format.xml  { head :created, :location => post_url(@post) }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to post_url(@post) }
#        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
#      format.xml  { head :ok }
    end
  end

  # POST /posts/1;preview
  def preview
    if params.has_key?(:id)
      @post = Post.find(params[:id])
      @post.attributes = params[:post]
    else
      @post = Post.new(params[:post])
    end
    if params[:post]
      begin
        render :partial => 'post/post', :layout => false
      rescue => e
        render :text => "Error : " + e.to_s, :layout => false
      end
    else
      render :nothing => true
    end
  end

  # POST /admin/posts/new_preview
  def new_preview
    preview
#    @post = Post.new(params[:post])
#    if params[:post]
#      render :partial => 'post/post'
#    else
#      render :nothing => true
#    end
  end

  # POST /admin/posts/1;version
  def version
    @post = Post.find(params[:id])
    @number = params[:number]
    @old_post = @post.find_version(@number)  
    
    respond_to do |format|
      format.html # version.rhtml
#      format.xml  { render :xml => @old_post.to_xml }
      format.js { render :partial => 'old_post', 
                         :object => @old_post, 
                         :locals => { :number => @number, :post => @post } }
    end
  end
  
  # POST /admin/posts/1;revert
  def revert
    @post = Post.find(params[:id])
    @post.revert_to(params[:number])

    respond_to do |format|
      format.html { render :action => 'edit' }
#      format.xml  { head :ok }
    end    
  end
  
  protected
  def set_webpage
    @webpage = Webpage.create("admin/posts") unless request.xhr?
    return true
  end
end