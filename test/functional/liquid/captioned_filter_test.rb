require File.dirname(__FILE__) + '/../../test_helper'

class CaptionedFilterTest < Test::Unit::TestCase
  fixtures :photos, :comatose_pages
  fixtures :photo_sets, :photos_photo_sets
  
  def setup
    @controller = ComatoseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::UrlWriter::default_url_options = {:host => @request.host }
    
    assert @processing_context = Comatose::ProcessingContext.new(ComatosePage.find(5))
    assert @strainer = Liquid::Strainer.create(@processing_context)
  end
  
  def test_filter_responds
    assert @strainer.respond_to?(:captioned_thumb)
  end
  
  def test_thumb_from_id
    assert @strainer.captioned_thumb('101')
  end

  def test_thumb_from_title
    assert @strainer.captioned_thumb('Photo 3')
  end
  
  def test_thumb_not_from_photo_set
    assert @strainer.captioned_thumb('3')
  end
end  