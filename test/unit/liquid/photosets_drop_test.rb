require File.dirname(__FILE__) + '/../../test_helper'

class PhotosetsDropTest < Test::Unit::TestCase
  fixtures :photos, :comatose_pages
  fixtures :photo_sets, :photos_photo_sets
  
  def setup
    assert @processing_context = Comatose::ProcessingContext.new(ComatosePage.find(3))
    assert @processing_context.has_key?('photosets')
    assert @drop = @processing_context['photosets']
    @drop.context = @processing_context
    assert @drop.to_liquid
  end
  
  def test_contents
    assert ps = @drop.contents
    assert_equal 3, ps.count
    assert_equal :photo_set, ps.title_source
    ps.photos do |photo_set, photo|
      assert [5, 4, 6].include?(photo_set.id)
      assert_equal photo_set.contents_photo, photo
    end
  end
end