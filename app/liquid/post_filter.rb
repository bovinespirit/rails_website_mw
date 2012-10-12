module PostFilter
  class Bucket
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::DateHelper
    include ApplicationHelper
    include ActionController::UrlWriter
    include PostHelper
  end
  
  def show_posts(tag, limit = 5)
    if tag == 'all'
      posts = Post.find_recent(limit, :include => :tags)
    end
    bucket = Bucket.new
    return "No posts found" if posts.nil?
    str = '<dl class="posts">'
    posts.each do |post|
      str << "<dt>#{bucket.post_link(post)}</dt>"
      str << '<dd>'
      str << "Created: #{bucket.show_time(post.created_at, true)} | "
      str << "Updated: #{bucket.show_time(post.updated_at, true)} | "
      str << "Tags: #{bucket.show_tags(post)}"
      str << "</dd>"
    end
    str << "</dl>"
    return str
  end
end

Liquid::Template.register_filter(PostFilter)
