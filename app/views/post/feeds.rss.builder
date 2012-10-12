xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "Bovine Spirit"
    xml.description "The ramblings of Matthew West"
    xml.link        blogindex_url(:only_path => false)
    xml.pubDate     CGI.rfc1123_date(@posts.first.updated_at) if @posts.any?

    @posts.each do |post|
      xml.item do
        xml.title       post.title
        xml.link        post_permaurl(post)
        xml.description process_text(post.body, "Textile", { :obj => post })
        xml.pubDate     CGI.rfc1123_date(post.updated_at)
        xml.guid('isPermaLink' => 'false') { xml << post.guid }
        xml.author      "spam@matthewwest.co.uk(Matthew West)"
      end
    end

  end
end