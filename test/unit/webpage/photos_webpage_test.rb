require File.dirname(__FILE__) + '/../../test_helper'

class PhotosWebpageTest < Test::Unit::TestCase
  fixtures :comatose_pages
  fixtures :photos
  fixtures :photo_sets
  fixtures :photos_photo_sets

  def test_pps_titles
    assert photo = Photo.find(2)
    assert photo_set = photo.photo_sets.find(:first)
    assert pps = PhotosPhotoSet.find_by_pps(photo, photo_set)
    assert webpage = Webpage.create(pps)
    assert "#{photo_set.title} - #{photo.title}", webpage.title
    assert photo.title, webpage.crumb_title
    assert photo.title, webpage.menu_title
  end
  
  def test_next_prev
    assert photo = Photo.find(104)
    assert photo_set = PhotoSet.find(5)
    assert pps = PhotosPhotoSet.find_by_pps(photo, photo_set)
    assert webpage = Webpage.create(pps)
    assert_equal "#{photo_set.title} - #{photo.next(photo_set).title}", webpage.next.title
    assert_equal "#{photo_set.title} - #{photo.prev(photo_set).title}", webpage.prev.title
  end
  
  def test_photo_set_children
    assert photo_set = PhotoSet.find(5)
    assert webpage = Webpage.create(photo_set.page)
    assert_equal 7, webpage.children.size
    assert_equal 0, webpage.menu_children.size
    assert_equal webpage, webpage.children[0].parent
    assert_equal 1, webpage.children[0].position
    assert_equal "Collection of Photos - Photo 7", webpage.children[0].title
    assert_equal "Collection of Photos - Photo 5", webpage.children[2].title
    assert_equal 7, webpage.children[6].position
    assert_equal "Collection of Photos - Photo 1", webpage.children[6].title
  end
  
  def test_next
    assert photo = Photo.find(104)
    assert photo_set = PhotoSet.find(5)
    assert pps = PhotosPhotoSet.find_by_pps(photo, photo_set)
    assert ppswp = Webpage.create(pps)
    assert pswp = ppswp.parent
    assert_equal "Collection of Photos", pswp.title
    assert_equal 7, ppswp.parent.children.size
    assert_equal 7, pswp.children.size
    assert_equal 4, ppswp.position
    assert_equal "#{photo_set.title} - #{photo.next(photo_set).title}", ppswp.next.title    
  end
end  