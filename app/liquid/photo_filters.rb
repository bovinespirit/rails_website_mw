# Usage:
#
#  {{ photoset.for_this_page | only_these: '1, 2, 3' | thumb_cards: 'small', 'notitle', 'floatr' }}

module PhotoSetFilters
  # See captioned_filter for explanation of bucket
  class Bucket
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include ApplicationHelper
    include ActionController::UrlWriter
    
    public
    # photoshow_url is a protected method...
    def photolink(photo_set, photo)
      photoshow_url(:photo_set => photo_set, :photo => photo)
    end
    
    def photo_set_link(photo_set)
      link_to photo_set.title, photo_set.uri
    end
  end
  
  def thumb_cards(input, size = 'medium', title = 'title', classes = 'float')
    begin
      bucket = PhotoSetFilters::Bucket.new

      str = ""
      str << "No photos in collection" if input.count == 0
      input.photos do |photo_set, photo|
        tstr = nil
        url = "#"
        if input.title_source == :photo
          url = bucket.photolink(photo_set, photo)
          tstr = photo.has_title? ? photo.title : "" if title == 'title'
        elsif input.title_source == :photo_set
          url = photo_set.uri
          tstr = photo_set.title if title == 'title'
        end
        str << bucket.thumb_card(input, photo, size, tstr, url, classes)
      end
      str
    rescue
      "<pre>#{$!}</pre>"
    end
  end
  
  # Select a few photos from a set
  def only_these(input, str)
    ids = str.split(',').collect { |s| s.to_i }
    input.only(ids)
  end
end

Liquid::Template.register_filter(PhotoSetFilters)
