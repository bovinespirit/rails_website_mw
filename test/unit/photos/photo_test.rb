require File.dirname(__FILE__) + '/../../test_helper'

class PhotoTest < Test::Unit::TestCase
  fixtures :comatose_pages, :photo_sets
  fixtures :photos_photo_sets
  fixtures :photos

  def setup
    @photo = Photo.find(1)
  end

  def test_destroy
    assert ps = @photo.photo_sets.find(:first)
    @photo.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Photo.find(@photo.id) }
    assert PhotoSet.find(ps.id)  
    assert_nil PhotosPhotoSet.find_by_pps(@photo, ps)
  end

  def test_fixtures_valid
    assert @photo.valid?
    assert Photo.find(2).valid?
  end

  def test_slug_from_title
    @photo.title = ""
    @photo.slug = ""
    @photo.title = "test"
    assert @photo.valid?
    assert_equal @photo.slug, @photo.title
    @photo.slug = ""
    @photo.title = "My Photo"
    assert @photo.valid?
    assert_equal @photo.slug, "my-photo"
  end
  
  def test_get_photo_size
    sz = @photo.size
    assert_equal sz[0], @photo.width
    assert_equal sz[1], @photo.height
  end
  
  def test_thumb_size_vertical
    sz = add_padding_to_size(Photo.thumb_size('small', false))
    assert sz[1] < sz[0]
    sz = add_padding_to_size(Photo.thumb_size('small', true))
    assert sz[0] < sz[1]
  end
  
  def test_thumb_double_length
    xxsmsz = add_padding_to_size(Photo.thumb_size('xxsmall', false))
    xsmsz = add_padding_to_size(Photo.thumb_size('xsmall', false))
    smsz = add_padding_to_size(Photo.thumb_size('small', false))
    mesz = add_padding_to_size(Photo.thumb_size('medium', false))
    lasz = add_padding_to_size(Photo.thumb_size('large', false))
    assert_equal xxsmsz[1] * 2, xsmsz[0]
    assert_equal xsmsz[1] * 2, smsz[0]
    assert_equal smsz[1] * 2, mesz[0]
    assert_equal mesz[1] * 2, lasz[0]
  end

  # Thumbnail sizing
  # Gives a thumbnail size automatically on create
  
  def test_thumb_size_too_big
    assert @photo.valid?
    @photo.thumb_l = 169
    assert !@photo.valid?
  end

  def test_thumb_size_vertical
    @photo.thumb_vertical = true
    assert !@photo.valid?
    @photo.thumb_l = 118
    assert @photo.valid?
  end
  
  def test_thumb_size_offset
    @photo.thumb_x, @photo.thumb_y = [16, 11]
    @photo.thumb_l = 152
    assert @photo.valid?
    @photo.thumb_l = 153
    assert !@photo.valid?
    @photo.thumb_l = 152
    @photo.thumb_x, @photo.thumb_y = [17, 11]
    assert !@photo.valid?
    @photo.thumb_x, @photo.thumb_y = [16, 12]
    assert !@photo.valid?
  end
  
  def test_thumb_size_set_on_height
    assert ph = Photo.new()
    ph.width = 160
    ph.height = 80
    assert ph.save
    assert_equal 80, ph.thumb_l
    assert_equal false, ph.thumb_vertical
  end
  
  def test_thumb_size_set_on_width
    assert ph = Photo.new()
    ph.width = 160
    ph.height = 120
    assert ph.save
    assert_equal 160, ph.thumb_l
    assert_equal false, ph.thumb_vertical
  end

  def test_thumb_size_set_vertical
    assert ph = Photo.new()
    ph.width = 120
    ph.height = 160
    assert ph.save
    assert_equal 160, ph.thumb_l
    assert_equal true, ph.thumb_vertical
  end

  # PhotoSet stuff...
  
  def test_next
    assert ps = PhotoSet.find(3)
    assert next1 =  @photo.next(ps)
    assert_equal next1.id, 2
    assert next2 = next1.next(ps)
    assert_equal next2.id, 3
    assert next3 = next2.next(ps)
    assert_equal next3.id, 4
    assert next1.position(ps) > @photo.position(ps)
    assert next2.position(ps) > next1.position(ps)
    assert next3.position(ps) > next2.position(ps)
    assert_equal @photo.next(ps, next1).id, next2.id
    assert_equal @photo.next(ps, @photo).id, next1.id 
    assert_equal @photo.next(ps, next2).id, next1.id
    assert_equal next1.next(ps, @photo).id, next2.id
    assert_equal next1.next(ps, next2).id, next3.id
    assert_equal next3.next(ps, next2), nil
    assert_equal next2.next(ps, next3), nil
  end
  
  def test_prev
    assert ps = PhotoSet.find(3)
    assert last = Photo.find(4)
    assert prev1 = last.prev(ps)
    assert_equal prev1.id, 3
    assert prev2 = prev1.prev(ps)
    assert prev3 = prev2.prev(ps)
    assert prev3.position(ps) < prev2.position(ps)
    assert prev2.position(ps) < prev1.position(ps)
    assert prev1.position(ps) < last.position(ps)
    assert_equal last.prev(ps, prev1).id, prev2.id
    assert_equal last.prev(ps, last).id,  prev1.id
    assert_equal last.prev(ps, prev2).id, prev1.id
    assert_equal prev1.prev(ps, last).id, prev2.id
    assert_equal prev1.prev(ps, prev2).id, prev3.id
    assert_nil prev3.prev(ps, prev2)
    assert_nil prev2.prev(ps, prev3)
  end
  
  def test_prev_next
    assert ps = PhotoSet.find(3)
    assert_equal @photo.id, @photo.next(ps).prev(ps).id
  end
  
  def test_lonely_next_prev
    assert ps = photo_sets("lonely_photo_set")
    assert lonely = Photo.find_by_slug('lonely-photo')
    assert_nil lonely.next(ps)
    assert_nil lonely.prev(ps)
  end
  
  def test_wrong_photo_set
    assert ps = photo_sets("lonely_photo_set")
    assert_raise(RuntimeError) { @photo.next(ps) }
    assert_raise(RuntimeError) { @photo.prev(ps) }
  end
  
  def test_homeless
    assert pa = Photo.find_homeless
    assert_equal 2, pa.size
    assert_equal 8, pa.first.id
  end
  
  def test_move_up
    assert ps = PhotoSet.find(5)
    assert ph = ps.photos[2]
    assert pos = ph.position(ps)
    assert ph.move_up(ps)
    assert_equal pos, ph.position(ps) + 1
  end
  
  def test_move_down
    assert ps = PhotoSet.find(5)
    assert ph = ps.photos[2]
    assert pos = ph.position(ps)
    assert ph.move_down(ps)
    assert_equal pos, ph.position(ps) - 1
  end
  
  def test_remove_from
    assert ps = PhotoSet.find(5)
    assert ph = ps.photos[2]
    assert count = ps.photos.count
    assert ph.remove_from(ps)
    assert Photo.find(ph.id)
    assert_equal count - 1, ps.photos.count
  end
  
  def test_find_all_but_photo_set
    assert ps = PhotoSet.find(5)
    assert pl = Photo.find_all_but_photo_set(ps)
    assert ar = pl.collect { |photo| photo.id }
    assert ar.include?(1)
    assert ar.include?(5)
    assert !ar.include?(101)
    assert !ar.include?(107)
  end
  
  def test_find_all_but_empty_photo_set
    assert ps = PhotoSet.new(:page => ComatosePage.find(1))
    assert ps.save
    assert pl = Photo.find_all_but_photo_set(ps)
    assert_equal Photo.find(:all).size, pl.size
  end
  
  def test_photo_title
    assert ph = Photo.find(9)
    assert_equal "Photo 9", ph.title
    assert !ph.has_title?
    assert ph.title = "Photo 9"
    assert !ph.has_title?
    assert ph.title = ""
    assert ph.save
    assert ph = Photo.find(9)
    assert !ph.has_title?
    assert ph.title = "Test"
    assert ph.has_title?
    assert_equal "Test", ph.title     
  end
  
  def test_alter_photo_sets_add
    hsh = { '6' => '1', '3' => '1', '4' => '1', '5' => '1'}
    assert ph = Photo.find(101)
    ph.alter_photo_sets(hsh)
    for i in [6, 3, 4, 5]
      assert ph.photo_sets.find(i)
    end
  end
  
  def test_alter_photo_sets_delete
    hsh = { '6' => '1', '3' => '1', '4' => '1'}
    assert ph = Photo.find(101)
    ph.alter_photo_sets(hsh)
    assert ph.photo_sets.find(6)
    assert ph.photo_sets.find(3)
    assert ph.photo_sets.find(4)
    assert_nil ph.photo_sets.find_by_id(5)
    ph.reload
    hsh = { '3' => '1'}
    ph.alter_photo_sets(hsh)
    assert_nil ph.photo_sets.find_by_id(6)
    assert ph.photo_sets.find(3)
    assert_nil ph.photo_sets.find_by_id(4)
  end

  def test_alter_photo_sets_invert
    hsh = { '6' => '1', '4' => '1'}
    assert ph = Photo.find(101)
    ph.alter_photo_sets(hsh)
    assert ph.photo_sets.find(6)
    assert_nil ph.photo_sets.find_by_id(3)
    assert ph.photo_sets.find(4)
    assert_nil ph.photo_sets.find_by_id(5)
    ph.reload
    hsh = { '3' => '1', '5' => '1'}
    ph.alter_photo_sets(hsh)
    assert_nil ph.photo_sets.find_by_id(6)
    assert ph.photo_sets.find(3)
    assert_nil ph.photo_sets.find_by_id(4)
    assert ph.photo_sets.find(5)  
  end
end