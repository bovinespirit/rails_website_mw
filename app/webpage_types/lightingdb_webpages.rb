# Webpages used in lightingdb/

Webpage.webpage_for_uri("lightingdb") do
  def initialize(obj, depth = 0, locals = {})
    @uri = "/lightingdb"
    @title = "Lighting Database"
    @updated_on = nil
    super
  end
  
  def load_parent; Comatose::PageWrapper.create_from_slug('home-page'); end  
  def load_children; Manufacturer.lantern_makers; end
end

Webpage.webpage_for_class(Manufacturer) do
  def initialize(obj, depth = 0, locals = {})
    @object = obj
    @uri = "/lightingdb/showmanufacturer/#{@object.name}"
    @title = @object.name
    super
  end
  
  def load_parent; "lightingdb"; end
  def load_children
    Lantern.find(:all, {:conditions => {:manufacturer_id => @object.id}, :include => :error_messages}).to_a
  end
end

Webpage.webpage_for_class(Lantern) do
  def initialize(obj, depth = 0, locals = {})
    @object = obj
    @title = @object.name
    super
    @uri = "/lightingdb/showlantern/#{parent.title}/#{@object.name}"
  end
  
  def section?
    true
  end
  protected
  def load_parent; @object.manufacturer; end
  def load_children
    ar = []
    ar << {:object => 'lightingdb/showgobos', :lantern => @object} if @object.gobo_wheels.count > 0
    ar << {:object => 'lightingdb/showerrors', :lantern => @object} if @object.error_messages.first
    return ar
  end
end

Webpage.webpage_for_uri('lightingdb/showgobos') do
  def initialize(obj, depth, locals)
    @lantern = locals[:lantern]
    @crumb_title = "Gobos"
    @menu_title = "Gobos"
    super
    @title = "#{parent.title} - Gobos"
    @uri = "/lightingdb/showgobos/#{parent.parent.title}/#{parent.title}"
  end
  
  def load_parent; @lantern; end
end

Webpage.webpage_for_uri('lightingdb/showerrors') do
  def initialize(obj, depth, locals)
    @lantern = locals[:lantern]
    @menu_title = @crumb_title = "Errors"
    super
    @uri = "/lightingdb/showerrors/#{parent.parent.title}/#{parent.title}"
    @title = "#{parent.title} - Errors"
  end

  def section?
    true
  end

  protected
  def load_parent; @lantern; end
  def load_children
    @lantern.error_messages.to_a.collect{ |error| {:object => error, :lantern => @lantern} }
  end
end

Webpage.webpage_for_class(ErrorMessage) do
  def initialize(obj, depth, locals)
    @lantern = locals[:lantern]
    @object = obj
    @menu_title = @crumb_title = @object.error
    super
    @uri = "/lightingdb/showerror/#{parent.parent.parent.title}/#{parent.parent.title}/#{@object.error}"
    @title = "#{parent.parent.title} - Error:#{@object.error}"
  end
  
  def load_parent; {:object => 'lightingdb/showerrors', :lantern => @lantern}; end
end
