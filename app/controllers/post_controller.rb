class PostController < ApplicationController
  def index
    opts = session[:user].nil? ? {:conditions => {:staging => false}} : {}
    @post_count = Post.count(opts)
    opts.merge!( :order => 'created_at DESC' )
    opts.merge!(:page => params[:page])
    @posts, @page = Post.paginate(:all, opts)
    @webpage = Webpage.create({:object => 'blog', :page => @page})
  end

  def date
    @date = {}
    [:year, :month, :day].each { |k| @date[k] = params[k] unless params[k].nil? }
    @post_count = Post.count_by_date_and_id(params, !session[:user].nil?)
    if params[:id] and @post_count == 0
      page_unknown
    elsif @post_count == 1
      @post = Post.find_by_date_and_id(params, !session[:user].nil?).first
      @webpage = Webpage.create(@post)
      @recent = Post.find_recent(5)
      render :action => :show
    else
      @posts, @page = Post.paginate_by_date(params, !session[:user].nil?)
      @webpage = Webpage.create({:object => 'blog', :page => @page}.merge(@date))
      render :action => :index
    end
  end

  def feeds
    @posts = Post.find(:all, :order => 'updated_at DESC', :limit => 10, :include => :tags)
    respond_to do |format|
      format.html { render :nothing }
      format.atom { render :layout => nil }
      format.rss { render :layout => nil }
    end
  end
end
