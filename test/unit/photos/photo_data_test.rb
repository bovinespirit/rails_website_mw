require File.dirname(__FILE__) + '/../../test_helper'

# Mighty bodge to get Photo.data= to work
class File < IO
  def size
    File.size(self.path)
  end
end

class PhotoDataTest < Test::Unit::TestCase
  fixtures :photos

  def setup
    @photo = Photo.find(1)
    @test_data_dir = File.dirname(__FILE__) + '/../../test_data/'
  end

  def test_data_read_write
    @photo.data = File.open(@test_data_dir + "testimage1.jpg")
    assert @photo.has_data?
    assert new_data = @photo.data
    assert new_data
    assert_valid @photo
    assert @photo.save
    assert PhotoData.find_by_photo_id(@photo.id)
    assert_equal new_data, @photo.data

    new_photo = Photo.find(@photo.id)
    assert_equal new_data, new_photo.data 
  end
  
  def test_change_data
    assert @photo.data = File.open(@test_data_dir + "testimage1.jpg")
    assert data = @photo.data
    assert @photo.save
    assert @photo = Photo.find(@photo.id)
    assert_equal data, @photo.data
    assert @photo.data = File.open(@test_data_dir + "testimage2.jpg")
    assert new_data = @photo.data
    assert data != @photo.data
    assert @photo.save
    assert @photo = Photo.find(@photo.id)
    assert data != @photo.data
    assert_equal new_data, @photo.data
  end
  
  def test_new_data
    newphoto = Photo.new()
    assert !newphoto.has_data?
    assert_nil newphoto.data
  end
  
# Regression testing using data created by scripts/create_photo_test_data
  def test_create_main
    assert @photo.data = File.open(@test_data_dir + "BristolRiver.jpg")
    assert rgdata = File.open(@test_data_dir + "main.jpg").read
    compare_data @photo.data, rgdata
    assert @photo.save
    assert @photo = Photo.find(@photo.id)
    assert data = @photo.data
    compare_data data, rgdata
  end
  
  def test_create_thumb
    assert @photo.data = File.open(@test_data_dir + "BristolRiver.jpg")
    @photo.thumb_x = 50
    @photo.thumb_y = 50
    @photo.thumb_l = 200
    @photo.thumb_vertical = false
    assert phdata = @photo.resize_thumb('small')
    assert rgdata = File.open(@test_data_dir + "small.jpg").read
    compare_data phdata, rgdata
  end
  
  protected
  def compare_data(data1, data2)
    assert_equal data1.size, data2.size
    [10, 100, 500, 1000].each { |i| assert_equal data1[i], data2[i] }
    [1500...1700].each { |i| assert_equal data1[i], data2[i] }
  end
end
