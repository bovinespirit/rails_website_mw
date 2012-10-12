module WebsiteHelper
  def make_sitemap_xml(xml, webpage)
    xml.url do
      xml.loc("http://#{request.host_with_port}#{webpage.uri}")
      t = webpage.updated_on
      xml.lastmod(t.to_formatted_s(:iso8601)) if !t.nil?
      xml.changefreq(webpage.changefreq)
      priority = case webpage.depth
      when 0
        1
      when 1
        0.8
      else
        0.2
      end
      xml.priority(priority)
    end
    webpage.children.each { |child| make_sitemap_xml(xml, child) }
  end
end