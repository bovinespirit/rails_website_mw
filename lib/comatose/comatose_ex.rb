#
# Overrides for Comatose classes
#
# Adds menu_title and id to Comatose::PageWrapper, giving access to underlying object attributes
# ComatoseAdmin: Enables sessions, defines authorize, adds createphotoset method 
# ComatoseController: Redirects 404s to ApplicationController 

require "#{RAILS_ROOT}/lib/url_filter"

# Create @@ variables before class definitian can add to them
Comatose::PageWrapper.new(nil)
ComatosePage.new()

class ComatosePage
  has_many :redirections, :as => :targetable, :dependent => :nullify
  has_one :photo_set, :as => :page, :dependent => :nullify
end

class Comatose::PageWrapper
  @@allowed_methods << ['menu_title']
  @@custom_methods << ['id', 'page', 'photo_set']
  
  class << self
    def create_from_slug(slug)
      Comatose::PageWrapper.new(ComatosePage.find_by_slug(slug))
    end
  end 

  def page
    @page
  end
  
  def id
    @page[:id]
  end
  
  def photo_set
    @page.photo_set
  end
end

# Set UrlWriter before it can be useful
#class ComatoseController
#  session :new_session => false
#  before_filter UrlFilter
#  layout 'layouts/application'
#
## Render a specific page
#  def show
#    page_name = get_page_path[0]
#    page = Comatose::Page.find_by_path( page_name )
#    if page.nil? or (page.has_keyword?('staging') and session[:user].nil?)
#      page_unknown
#    else
#      # Make the page access 'safe' 
#      @page = Comatose::PageWrapper.new(page)
#      # For accurate uri creation, tell the page class which is the active mount point...
#      Comatose::Page.active_mount_info = get_active_mount_point(params[:index])
#      render :text=>page.to_html({'params'=>params.stringify_keys}),
#             :layout=>get_page_layout
#    end
#  end
#end

module Admin
  class ComatoseAdminController < ComatoseAdminController
    layout 'layouts/application'
    before_filter UrlFilter
    unloadable
 
    def createphotoset
      ps = nil
      @page = ComatosePage.find(params[:id])
      ps = PhotoSet.create_from(@page) if @page
      flash[:notice] = "Photo set created" if ps
      redirect_to :action => 'edit', :id => params[:id]
    end
  end
end
