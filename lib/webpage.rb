
# Class describing one page of the website
# Leads to a whole tree of pages describing the whole site...
# Used to create menus, links, sitemap etc

class Webpage
  include ActionController::UrlWriter
  CHANGEFREQ = {
    :always => 'always',
    :hourly => 'hourly',
    :daily => 'daily',
    :weekly => 'weekly',
    :monthly => 'monthly',
    :yearly => 'yearly',
    :never => 'never'
  }
  attr_reader :menu_title, :updated_on, :uri, :depth, :type, :crumb_title, :show_in_menu, :object
  attr_accessor :title, :position, :show_admin
  cattr_reader :subclasses 
  @@subclasses = {}
  
  def initialize(obj = {}, depth = 0, locals = {})
    if obj.is_a?(Hash)
      obj.stringify_keys!
      obj.each { |k, v| send("#{k}=", v) }
    end
    @object ||= obj
    @parent ||= locals[:parent]
    @position = locals[:position]
    @active_child = locals[:active_child]
    @show_admin = locals[:show_admin]
    @menu_title ||= @title if @title
    @crumb_title ||= @title if @title
    @depth = (depth > 0) ? depth : 0
    @current = false
    @open = false
    @admin ||= false
    @changefreq ||= :monthly
    @children ||= nil
    @show_in_menu ||= true
    @type = @object.class
  end
  
  class << self
    def create(obj)
      wb = Webpage.from(obj, 0, {})
      if !wb.nil?
        wb.show_admin = wb.admin?
        wb.set_current
      end
      return wb
    end
    
    def from(obj, depth = 0, locals = {})
      return nil if obj.nil?
      
      obj, locals = obj[:object], obj.merge(locals) if obj.is_a?(Hash)
      
      obj = obj.page if obj.is_a?(PhotoSet)
      obj = Comatose::PageWrapper.new(obj) if obj.is_a?(ComatosePage)
      obj = obj.slug if obj.is_a?(Comatose::PageWrapper) and @@subclasses.has_key?(obj.slug)
      
      return @@subclasses[obj].new(obj, depth, locals) if obj.is_a?(String) and @@subclasses.has_key?(obj)
      
      klass = @@subclasses[obj.class]
      return klass.new(obj, depth, locals) if !klass.nil?
      
      raise "Webpage cannot be created from class: #{obj.class}\n"
    end
    
    def webpage_for_class(obj_klass, &block)
      klass = Class.new(self)
      klass.class_eval(&block)
      @@subclasses[obj_klass] = klass
      return klass
    end
    
    def webpage_for_uri(uri, &block)
      klass = Class.new(self)
      klass.class_eval(&block)
      @@subclasses[uri] = klass
      return klass
    end
    
    # Returns a array the names of classes that can be made into Webpages
    def class_list
      ar = []
      @@subclasses.each { |k, v| ar << k.to_s if !k.is_a?(String) }
      ar << PhotoSet.to_s                # PhotoSet does not have a direct webpage
      ar.delete("Comatose::PageWrapper") # Want the Page object
      ar << ComatosePage.to_s          # not the PageWrapper
      ar
    end
    
    # Returns a hash of the titles of pages that can be made from a class
    # { title => id }
    def pages(klass_name)
      return {} if klass_name.nil?
      ar = {}
      klass = eval(klass_name)
      klass.find(:all).each do |obj|
        wb = Webpage.from(obj)
        ar[wb.title] = obj.id
      end
      ar.sort
    end
  end
  
  # sitemaps change frequency
  def changefreq
    CHANGEFREQ[@changefreq]
  end
  
  # If the current page is a section then it's children should be displayed
  def open?
    return !@active_child.nil?
  end
  
  # Does this object represent the current page?
  def current?
    @current
  end
  
  # Is this page the index of a section?
  def section?
    return menu_children.size > 0
  end
  
  # Is this an admin page?
  def admin?
    @admin
  end
  
  # Points to a page that allows editing of this page
  def edit_url
    nil
  end
  
  # Staging pages are only visable if show_admin == true
  def staging?
    false
  end
  
  # Creates a breadcrumb trail
  def crumbs(&block)
    crumb = next_crumb
    while !crumb.nil?
      cr = crumb
      crumb = crumb.next_crumb
      yield cr, !crumb.nil?
    end
  end
  
  def next_crumb
    @active_child
  end
  
  # Next page, nil if it's the last
  def next
    @next ||= begin
      if has_next?
        parent.children[position]
      else
        nil
      end
    end
  end
  
  # Previous page, nil if it's the first
  def prev
    @prev ||= begin
      if has_prev?
        parent.children[position - 2]
      else
        nil
      end
    end
  end
  
  def has_next?
    if !parent.nil?
      parent.children if position.nil?
      return parent.children.size > position
    end
    return false
  end
  
  def has_prev?
    if !parent.nil?
      parent.children if position.nil?
      return position > 1 unless position.nil?
    end
    return false
  end
  
  def first
    parent.nil? ? nil :  parent.children.first
  end
  
  def last
    parent.nil? ? nil : parent.children.last
  end
  
  # Parent webpage, nil if webpage is index
  def parent
    @parent ||= Webpage.from(load_parent, @depth - 1, :active_child => self, :show_admin => show_admin)
  end
  
  # Array of children
  # If show_admin is true, then include admin pages
  def children
    @children ||= begin
      ar = load_children
      if ![String, ErrorMessage].include?(@object.class)
        ps = PhotoSet.find_by_obj(@object, :include => :photos_photo_sets, :order => 'photos_photo_sets.position')
        ps.photos_photo_sets.each { |pps| ar << pps } if !ps.nil?
      end
      create_children(ar)
    end
  end
  
  def menu_children
    @menu_children ||= begin
      mc = children.dup
      mc.delete_if { |child| child.show_in_menu == false }
      mc
    end
  end
    
  def index
    @index ||= begin
      i = self
      while (i.parent != nil); i = i.parent; end 
      i
    end
  end
  
  def set_current
    @current = true
  end  
  
  protected
  def load_parent
    nil
  end
  
  def load_children
    []
  end

  private
  def create_children(child_objects)
    pos = 0
    ch = []
    has_active = false
    child_objects.each do |child|
      pos += 1
      wb = Webpage.from(child, @depth + 1, { :parent => self, :position => pos, :show_admin => show_admin })
      if !@active_child.nil? and !has_active and @active_child.uri == wb.uri
        wb = @active_child
        @active_child.position = pos
        has_active = true
      end
      if !show_admin and (wb.staging? or wb.admin?)
        pos -= 1
      else
        ch << wb
      end
    end
    unless @active_child.nil? or has_active
      @active_child.position = pos + 1
      ch << @active_child
    end
    ch
  end
end
