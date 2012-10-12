# Generate a sitemap for Google et al
# www.sitemaps.org

xml.instruct!
xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.84" do
  make_sitemap_xml(xml, @rootpage)
end
