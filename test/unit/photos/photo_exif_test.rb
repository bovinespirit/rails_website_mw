require File.dirname(__FILE__) + '/../../test_helper'

# Mighty bodge to get Photo.data= to work
class File < IO
  def size
    File.size(self.path)
  end
end

class PhotoExifTest < Test::Unit::TestCase
  fixtures :photos

  def setup
    @photo = Photo.find(:first)
    @test_data_dir = File.dirname(__FILE__) + '/../../test_data/'
  end

  def test_exif_read_same
    @photo.data = File.open(@test_data_dir + "exif_image.jpg")
    assert @photo.valid?
    assert @photo.save
    assert_equal @photo.width, 700
    assert_equal @photo.height, 525
    assert_equal @photo.camera_model, 'Canon PowerShot G5'
    assert_equal @photo.exposure, '1/60'
    assert_equal @photo.focal_length, 7.1
    assert_equal @photo.aperture, 6.3
    assert_equal  '2006-10-08 23:00:00 UTC', @photo.created_on.to_s
  end
  
  def test_exif_different_file
    assert @photo.camera_model, 'No data'
    @photo.data = File.open(@test_data_dir + "testimage1.jpg")
    real_data = @photo.data
    assert @photo.camera_model, 'No data'
    @photo.exif_image = File.open(@test_data_dir + "exif_image.jpg")
    assert @photo.save
    assert_equal @photo.data, real_data
    assert_equal @photo.width, 700
    assert_equal @photo.height, 700
    assert_equal @photo.camera_model, 'Canon PowerShot G5'
    assert_equal @photo.exposure, '1/60'
    assert_equal @photo.focal_length, 7.1
    assert_equal @photo.aperture, 6.3
    assert_equal '2006-10-08 23:00:00 UTC', @photo.created_on.to_s
  end

  def test_bristol_file
  # Bristol photo causes EXIF reader to choke
  # Because it's got a dodgy date in the EXIF data
    t = 1.day.ago
    assert @photo.created_on = t
    assert @photo.data = File.open(@test_data_dir + "BristolRiver.jpg")
    assert_valid @photo
    assert @photo.save
    assert_equal t, @photo.created_on
  end
end