require File.dirname(__FILE__) + '/../test_helper'

class PhotoSetTest < Test::Unit::TestCase
  fixtures :photos, :comatose_pages
  fixtures :photo_sets, :photos_photo_sets
  fixtures :tags

  def test_find_by_obj
    assert cp = ComatosePage.find(4)
    assert ps = PhotoSet.find_by_obj(cp)
    assert_equal cp.slug, ps.page.slug
    assert_equal cp.uri, ps.uri
  end
  
  def find_by_nil
    assert_equal nil, PhotoSet.find_by_obj("Wrong 'un")
  end    
  
  def test_find_by_wrapper
    assert cp = Comatose::PageWrapper.new(ComatosePage.find(4))
    assert ps = PhotoSet.find_by_obj(cp)
    assert_equal cp.uri, ps.uri
  end   
  
  def test_find_by_wrapper_nice
    assert cp = Comatose::PageWrapper.new(ComatosePage.find(4))
    assert ps = cp.photo_set
    assert_equal cp.uri, ps.uri
  end    
  
  def test_title
    assert cp = ComatosePage.find(5)
    assert ps = PhotoSet.find(5)
    assert_equal cp.title, ps.title
  end
  
  def test_title_destroy_page
    assert cp = ComatosePage.find(5)
    assert ps = PhotoSet.find(5)
    cp.destroy
    assert_nil ps.title
  end
  
  def test_change_of_title
    assert cp = ComatosePage.find(5)
    assert ps = PhotoSet.find(5)
    assert_equal cp.title, ps.title
    assert cp.title = "All Change"
    assert cp.save!
    ps.reload
    assert_equal cp.title, ps.title
  end

  def test_title_change_object
    assert ps = PhotoSet.find(5)
    assert cp = ComatosePage.find(2)
    assert ps.page = cp
    assert_equal cp.title, ps.title
  end  
  
  def test_uri
    assert cp = ComatosePage.find(5)
    assert ps = PhotoSet.find(5)
    assert_equal cp.uri, ps.uri
  end
  
  def test_comatose_type
    assert ps = PhotoSet.find(3)
    assert_equal "ComatosePage", ps.page_type
  end
  
  def test_same_page
    assert ps = PhotoSet.new(:page => ComatosePage.find(5))
    assert !ps.valid?
  end
  
  def test_photos
    assert ps = PhotoSet.find(5)
    assert_equal 7, ps.photos.count
    assert_equal Photo.find(107), ps.photos.first
    assert_equal Photo.find(101), ps.photos.last
  end
  
  def test_create_from
    assert cp = ComatosePage.find(1)
    assert ps = PhotoSet.create_from(cp)
    assert_equal ps.title, cp.title
    assert PhotoSet.find(ps.id)
    assert PhotoSet.find_by_obj(cp)
  end

  def test_destroy
    assert ps = PhotoSet.find(5)
    for i in 101..107
      assert ph = Photo.find(i)
      assert_equal 1, ph.photo_sets.count
    end
    ps.destroy
    assert_raise(ActiveRecord::RecordNotFound) { PhotoSet.find(ps.id) }
    for i in 101..107
      assert ph = Photo.find(i)
      assert_equal 0, ph.photo_sets.count
    end
  end
  
  def test_push
    assert ps = PhotoSet.find(5)
    assert_equal 7, ps.photos.count
    assert ph = Photo.find(1)
    ps.add_photo ph
    assert_equal 8, ps.photos.count
    assert_equal ps.photos.last.slug, ph.slug
    assert ph.reload
    assert_equal 8, ph.position(ps)
  end
  
  def test_push_with_position
    assert ps = PhotoSet.find(5)
    assert_equal 7, ps.photos.count
    assert ph1 = ps.photos[3]
    assert_equal 4, ph1.position(ps)
    assert ph = Photo.find(1)
    ps.insert_photo(ph, 4)
    assert ps.reload
    assert ph1.reload
    assert_equal 8, ps.photos.count
    assert_equal ps.photos[3].slug, ph.slug
    assert_equal 5, ph1.position(ps)
    assert ph.reload
    assert_equal 4, ph.position(ps)
  end
  
  def test_contents_photo
    assert ps = PhotoSet.find(5)
    assert ph = ps.contents_photo
    assert_equal 103, ph.id 
  end
  
  def test_contents_photo_nil
    assert ps = PhotoSet.find(4)
    assert ph = ps.contents_photo
    assert_equal 6, ph.id
  end
  
  def test_contents_photo_empty_photo_set
    assert ps = PhotoSet.new
    assert ps.save
    assert_nil ps.contents_photo
  end
  
  def test_contents_photo_not_in_photo_set
    assert ps = PhotoSet.find(5)
    assert ph = Photo.find(1)
    assert ps.contents_photo = ph
    assert !ps.valid?
    assert ps.contents_photo = Photo.find(104)
    assert ps.valid?
  end
  
  def test_add_photo_set
    assert ps = PhotoSet.find(5)
    assert_equal 7, ps.photos.count
    assert addps = PhotoSet.find(3)
    ps.add_photo_set(addps)
    assert_equal 11, ps.photos.count
    assert_equal ps.photos[7], addps.photos.first
  end
  
  def test_add_photo_set_already_some_there
    assert ps = PhotoSet.find(5)
    assert_equal 7, ps.photos.count
    assert addps = PhotoSet.find(3)
    ps.add_photo(addps.photos[2])
    ps.add_photo(addps.photos[0])
    assert_equal 9, ps.photos.count
    assert_equal ps.photos[8], addps.photos[0]
    ps.reload
    ps.add_photo_set(addps)
    assert_equal 11, ps.photos.count
    ps.reload
    assert_equal ps.photos[9], addps.photos[1]
  end
  
  def test_add_photo_set_reorder
    assert ps = PhotoSet.find(5)
    assert_equal 7, ps.photos.count
    assert addps = PhotoSet.find(3)
    ps.add_photo(addps.photos[2])
    ps.add_photo(addps.photos[0])
    assert_equal 9, ps.photos.count
    assert_equal ps.photos[8], addps.photos[0]
    ps.reload
    ps.add_photo_set(addps, true)
    assert_equal 11, ps.photos.count
    ps.reload
    assert_equal ps.photos[8], addps.photos[1]
    assert_equal ps.photos[9], addps.photos[2]
  end
  
  def test_add_photo_set_reorder_middle
    assert ps = PhotoSet.find(5)
    assert_equal 7, ps.photos.count
    assert addps = PhotoSet.find(3)
    ps.insert_photo(addps.photos[2], 3)
    ps.add_photo(addps.photos[1])
    assert_equal 9, ps.photos.count
    assert_equal ps.photos[8], addps.photos[1]
    ps.add_photo_set(addps, true)
    assert_equal 11, ps.photos.count
    ps.reload
    assert_equal ps.photos[2], addps.photos[0]
    assert_equal ps.photos[5], addps.photos[3]
    assert_equal ps.photos[10].id, 101
  end
  
  def test_tag_photos
    assert tag = Tag.find(1)
    assert ps = PhotoSet.find(5)
    assert photo = Photo.find(103)
    assert_nil photo.tags.find_by_id(1)
    assert photo.tags << tag
    assert ps.tag_photos(tag)
    [101, 103, 104, 107].each do |i|
      assert Photo.find(i).tags.find_by_id(1)
    end
  end
end
