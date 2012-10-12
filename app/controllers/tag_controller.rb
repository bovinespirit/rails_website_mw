class TagController < ApplicationController

  def index
    @webpage = Webpage.create("tags")
  end
  
  def show
    if params[:tag].nil?
      @webpage = Webpage.create("tags")
      render :action => :index
    else
      @tag = Tag.find_by_name(params[:tag])
      @webpage = Webpage.create(@tag)
    end
  end
end
