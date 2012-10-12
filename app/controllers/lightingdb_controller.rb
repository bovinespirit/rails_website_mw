class LightingdbController < ApplicationController

  def index
    @webpage = Webpage.create('lightingdb')
  end

  def show_manufacturer
    redirect_to(:action => :index) if !load_manufacturer
    @webpage = Webpage.create(@manufacturer)
  end

  def show_lantern
    redirect_to(:action => :index) if !load_lantern
    @webpage = Webpage.create(@lantern) 
  end

  def show_errors
    redirect_to(:action => :index) and return if !load_lantern
    @webpage = Webpage.create({:object => 'lightingdb/showerrors', :lantern => @lantern})
    if @lantern.error_messages.count == 0
      redirect_to(:action => :show_lantern, :manufacturer => params[:manufacturer], :lantern => params[:lantern])
    end
  end

  def show_error
    redirect_to(:action => :index) and return if !load_lantern
    @error = @lantern.error_messages.find_by_error(params[:error])
    if !@error
      redirect_to(:action => :show_errors, :manufacturer => params[:manufacturer], :lantern => params[:lantern])
    else
      @webpage = Webpage.create({:object => @error, :lantern => @lantern})
    end
  end

  def show_gobos
    redirect_to(:action => :index) and return if !load_lantern
    if @lantern.gobo_wheels.count == 0
      redirect_to(:action => :show_lantern, :manufacturer => params[:manufacturer], :lantern => params[:lantern])
    end
    @webpage = Webpage.create({:object => 'lightingdb/showgobos', :lantern => @lantern})
    @array = []
    for gw in @lantern.gobo_wheels
      numbers = []
      names = []
      imgs = []
      noimg = "gobos/smallblank.png"
      (1..gw.quantity).each do |i| 
        numbers << i.to_s
        gobo = gw.gobo(i)
        if gobo != nil
          names << gobo.description
          img = "gobos/small" + gobo.id.to_s + ".png"
          imgloc = File.dirname(__FILE__) + "/../../public/images/" + img
          if File.file?(imgloc)
            imgs << img
          else
            imgs << noimg
          end
        else
          names << "&#160;"
          imgs << false
        end
      end
      @array << { :name => gw.gobo_wheel_type.name, :numbers => numbers, :names => names, :imgs => imgs, :width => (100 / gw.quantity).to_s + "%" }
    end
  end

  private

  def load_lantern
    return false if !load_manufacturer
    @lantern = Lantern.find_by_name_and_manufacturer_id(params[:lantern], @manufacturer.id)
    if !@lantern
      return false
    end
    return true
  end
  
  def load_manufacturer
    @manufacturer = Manufacturer.find_by_name(params[:manufacturer])
    @manufacturer
  end
  
end

