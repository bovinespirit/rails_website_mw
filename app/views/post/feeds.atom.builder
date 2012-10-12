xml.instruct! :xml, :version => '1.0'

xml.feed 'xmlns' => 'http://www.w3.org/2005/Atom' do
  xml.title 'Bovine Spirit'
  xml.link :rel => 'self', :href => blogfeed_url(:only_path => false, :feed => 'atom')
  xml.link :rel => 'alternate', :href => blogindex_url(:only_path => false)
  xml.id blogindex_url(:only_path => false)
  xml.updated @posts.first.updated_at.to_s(:iso8601) if @posts.any?
  xml.author do 
    xml.name "Matthew West"
    xml.uri "http://www.matthewwest.co.uk"
  end
  xml.rights('type' => 'html') { xml << "Copyright &amp;copy; Matthew West 2002-2008" }
  
  @posts.each do |post|
     xml.entry do
      xml.title post.title
      xml.link :rel => "alternate", :href => post_permaurl(post)
      xml.id post.guid
      xml.updated(post.updated_at.to_s(:iso8601))
      xml.published(post.created_at.to_s(:iso8601))
      xml.content "type" => "xhtml" do
        xml.div('xmlns' => 'http://www.w3.org/1999/xhtml') do
          xml << process_text(post.body, "Textile", { :obj => post })
        end
      end
      post.tags.each do |tag|
        xml.category('term' => tag.name)
      end
    end
  end
end
  
  
  