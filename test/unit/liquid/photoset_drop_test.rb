require File.dirname(__FILE__) + '/../../test_helper'

class PhotosetDropTest < Test::Unit::TestCase
  fixtures :photos, :comatose_pages
  fixtures :photo_sets, :photos_photo_sets
  
  def setup
    assert @processing_context = Comatose::ProcessingContext.new(ComatosePage.find(5))
    assert @drop = @processing_context['photoset']
    @drop.context = @processing_context
    assert @drop.to_liquid
  end
  
  def test_for_this_page
    assert ps = @drop['for_this_page']
    assert_equal 7, ps.count
    assert_equal :photo, ps.title_source
    ps.photos do |photo_set, photo|
      assert_equal 5, photo_set.id
      assert photo_set.photos.find(photo.id)
    end
  end
  
  def test_id
    assert ps = @drop['id_3']
    assert_equal 4, ps.count
    assert_equal :photo, ps.title_source
    ps.photos do |photo_set, photo|
      assert_equal 3, photo_set.id
      assert photo_set.photos.find(photo.id)
    end
  end
  
  def test_only
    assert ps = @drop['for_this_page']
    assert_equal 7, ps.count
    assert ar = [101, 102, 104]
    assert nps = ps.only(ar)
    assert_equal 3, nps.count 
    nps.photos do |photo_set, photo|
      assert photo_set.photos.find(photo.id)
      assert ar.include?(photo.id)
    end
  end
end