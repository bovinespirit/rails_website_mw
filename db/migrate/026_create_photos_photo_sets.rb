class CreatePhotosPhotoSets < ActiveRecord::Migration
  def self.up
    create_table :photos_photo_sets do |t|
      t.column 'photo_id', :integer
      t.column 'photo_set_id', :integer
      t.column 'position', :integer
    end
    PhotosPhotoSet.reset_column_information    
    Photo.find(:all).each do |photo|
      if photo.photo_set_id != 0
        pps = PhotosPhotoSet.new(:photo_id => photo.id, :photo_set_id => photo.photo_set_id, :position => photo.position)
        pps.save
      end
    end
  end

  def self.down
    drop_table :photos_photo_sets
  end
end
