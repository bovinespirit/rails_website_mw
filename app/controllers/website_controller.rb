# Stuff that doesn't fit anywhere else and that relies on Webpage

class WebsiteController < ApplicationController
  def sitemap
    @rootpage = Webpage.create(Comatose::PageWrapper.create_from_slug('home-page'))
  end
end
