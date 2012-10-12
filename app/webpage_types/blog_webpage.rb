Webpage.webpage_for_uri("blog") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/blog"
    @date = {}
    @crumb_title = "Blog"
    @date[:time] = Time.gm(locals[:year] || Time.now.year, 
                           locals[:month] || Time.now.month, 
                           locals[:day] || Time.now.day, 00, 01)
    strf = (locals[:day] ? "%e " : "") + (locals[:month] ? "%B " : "") + (locals[:year] ? "%Y" : "")
    @date[:string] = @date[:time].strftime(strf)
    [:year, :month, :day].each do |k| 
      unless locals[k].nil?
        @uri << "/#{locals[k]}"
        @date[k] = locals[k]
        @crumb_title = (k == :month) ? @date[:time].strftime("%B") : locals[k]
      end
    end
    @page = locals[:page] || nil
    @title = "Blog"
    @title << " - #{@date[:string]}" unless @date[:string].empty?
    if @date[:time] > 5.weeks.ago
      @changefreq = :weekly
    else
      @changefreq = :yearly
    end
    @uri << (@date[:string].empty? ? "/page/#{@page}" : "?page=#{@page}") unless @page.nil?
    @updated_on = nil
    super
  end

  alias menu_title crumb_title
  
  def date; @date; end
  
  def load_parent
    if @date[:day]
      return {:object => 'blog'}.merge(:year => @date[:year]).merge(:month => @date[:month])
    elsif @date[:month]
      return {:object => 'blog'}.merge(:year => @date[:year])
    elsif @date[:year]
      return {:object => 'blog'}
    else
      return Comatose::PageWrapper.create_from_slug('home-page')
    end
  end
  
  def load_children
    Post.find_by_date_and_id(@date, show_admin, true)
  end
end

Webpage.webpage_for_class(Post) do
  def initialize(obj, depth = 0, locals = {})
    @post = obj
    @uri = "/blog/#{@post.created_at.year}/#{@post.created_at.month}/#{@post.created_at.day}/#{@post.to_param}"
    @changefreq = (1.month.ago > @post.updated_at) ? :yearly : :weekly
    @title = "Blog - #{@post.title}"
    @crumb_title = @menu_title = @post.title
    super
  end

  def show_in_menu; false; end

  def updated_on
    @post.updated_at.to_date
  end

  def edit_url
    edit_post_url(@post)
  end
    
  protected
  def load_parent
    'blog'
  end
end
