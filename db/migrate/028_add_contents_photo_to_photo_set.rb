class AddContentsPhotoToPhotoSet < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, 'contents_photo_id', :integer
  end

  def self.down
    remove_column :photo_sets, 'contents_photo_id'
  end
end
