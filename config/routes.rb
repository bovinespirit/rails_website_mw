ActionController::Routing::Routes.draw do |map|
  # Lighting Database Routes
  map.showlantern 'lightingdb/showlantern/:manufacturer/:lantern', :controller => 'lightingdb', :action => 'show_lantern'
  map.showgobos 'lightingdb/showgobos/:manufacturer/:lantern', :controller => 'lightingdb', :action => 'show_gobos'
  map.showerrors 'lightingdb/showerrors/:manufacturer/:lantern', :controller => 'lightingdb', :action => 'show_errors'
  map.showerror 'lightingdb/showerror/:manufacturer/:lantern/:error', :controller => 'lightingdb', :action => 'show_error'
  map.showgobos 'lightingdb/showgobos/:manufacturer/:lantern', :controller => 'lightingdb', :action => 'show_gobos'
  map.showmanufacturer 'lightingdb/showmanufacturer/:manufacturer', :controller => 'lightingdb', :action => 'show_manufacturer'

  # Stylesheets
  map.connect 'stylesheets/:rcss', :controller => 'stylesheet', :action => 'rcss', :requirements => { :rcss => /.*/ }

  # Tags
  map.tag_page 'tags/:tag', :controller => 'tag', :action => 'show',
                            :tag => nil

  # Photos
  map.photoshow 'photo/set/:photo_set/:photo', :controller => 'photo', :action => 'set'
  map.photonoset 'photo/show/:photo', :controller => 'photo', :action => 'show'
  map.thumb 'photo/img/:photo/:size', :controller => 'photo', :action => 'img', :requirements => { :size => /.*/ }
  map.thumbbg 'photo/imgbg/:photo/:size', :controller => 'photo', :action => 'imgbg', :requirements => { :size => /.*/ }
  map.carousel 'photo/carousel/:photo_set/:current/:photo/:dir', :controller => 'photo',
                                                   :action => 'carousel', :requirements => { :dir => /.*/ }

  # Blog
  map.blogpage 'blog/page/:page', :controller => 'post', :action => 'index', :page => 1
  map.postdate 'blog/:year/:month/:day/:id', :controller => 'post', 
                                             :action => 'date',
                                             :requirements => { :year => /(19|20)\d\d/, 
                                                                :month => /[01]?\d/,
                                                                :day => /[0-3]?\d/ },
                                             :month => nil,
                                             :day => nil,
                                             :id => nil
  map.blogfeed 'blog/feeds.:format', :controller => 'post', :action => 'feeds'
  map.blogindex 'blog', :controller => 'post', :action => 'index'
  
                                         
  # comatose_admin
  map.connect 'admin/comatose_admin/:action/:id', :controller => 'admin/comatose_admin', :layout => 'application'

  # Admin pages
  map.connect 'admin/', :controller => 'admin/admin', :action => 'index'
  map.login 'admin/login', :controller => 'admin/admin', :action => 'login'
  map.logout 'admin/logout', :controller => 'admin/admin', :action => 'logout'
  map.resources :redirections, :path_prefix => 'admin', 
                :controller => 'admin/redirections', 
                :collection => { :directionless => :get, :google_csv => :post }
  map.resources :photo_sets, :path_prefix => 'admin/',
                :controller => 'admin/photo_sets',
                :member => { :reorder => :any, :add_photo_set => :any } do |photo_set|
    photo_set.resources :photos, :controller => 'admin/photos',
                        :name_prefix => 'ps_',
                        :member => { :move_up => :any, :move_down => :any, :remove => :any, :add => :any }
  end
  map.resources :photos, :controller => 'admin/photos',
                :path_prefix => 'admin/', 
                :member => { :edit_thumbnail => :get,
                             :swap_vertical => :get },
                :collection => { :preview_text => :any }
  map.resources :contacts, :controller => 'admin/contacts',
                :path_prefix => 'admin/'
  map.resources :posts, :controller => 'admin/posts',
                :path_prefix => 'admin/',
                :member => { :preview => :any,
                             :version => :any,
                             :revert => :any },
                :collection => { :new_preview => :any }
  map.resources :tags, :controller => 'admin/tags',
                :path_prefix => 'admin/'
  map.untag 'admin/tags/untag/:id/:taggable_type/:taggable_id.:format', :controller => 'admin/tags', :action => 'untag'
  map.tag_photo_set 'admin/tags/tag_photo_set/:id/:photo_set.:format', :controller => 'admin/tags', 
                                                               :action =>'tag_photo_set'

  # Website bits
  map.sitemap 'sitemap.:format', :controller => 'website', :action => 'sitemap'  
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  # Comatose is even lower
  map.comatose_root '', :layout => "application"

end
