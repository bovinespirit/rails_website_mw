module PostHelper
  def post_permaurl(post)
    postdate_url(:year => post.created_at.year, 
                 :month => post.created_at.month,
                 :day => post.created_at.day,
                 :id => post.to_param)
  end

  # Create a permenant link to a post
  def post_link(post, title = post.title, bookmark = true)
    opts = {}
    opts.merge!(:rel => 'bookmark') if bookmark
    link_to h(title), post_permaurl(post), opts
  end

  def truncate_post(text, trunc)
    sp = text.index("</p>", trunc)
    return sp.nil? ? nil : text.slice(0, sp) + '...</p>'
  end
  
  def show_time(time, index)
    index ? "#{time_ago_in_words(time)} ago" : "at #{time.to_formatted_s(:long)}"
  end
end
