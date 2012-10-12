
# Filter for creating captioned photos
# 
# Use like:
# {{ 'title' | captioned_thumb: 'medium', 'float' }}
# Or:
# {{ 'id' | captioned_thumb }}
# 
# The photo must belong to the pages' photo_set

module CaptionedFilter
  # UrlWriter wants to be part of a proper class to work, as photoshow_url and friends
  # are created as protected methods of that class.
  class Bucket
    include ActionView::Helpers::TagHelper
    include ApplicationHelper
    include ActionController::UrlWriter
  end
  
  def captioned_thumb(title, size = "medium", cl = "")
    page = @context['page']
    page = ComatosePage.find(@context['params']['page']['id']) unless page.id
    photo_set = PhotoSet.find_by_obj(page)
    return "Page #{page.id}-#{page.title} does not have a PhotoSet object" unless photo_set
    photo = photo_set.photos.find_by_title(title)
    photo ||= photo_set.photos.find_by_id(title.to_i) if title.to_i 
    return "Photo '#{title}' not found or not part of this pages' photo_set <br /> " if photo.nil?
    "\n<notextile>\n#{CaptionedFilter::Bucket.new.captioned_thumb(photo_set, photo, size, {:class => cl})}\n</notextile>\n"
  end
end

Liquid::Template.register_filter(CaptionedFilter)
