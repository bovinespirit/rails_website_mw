class AddPhotoSetPageTypeIndex < ActiveRecord::Migration
  def self.up
    add_index :photo_sets, :page_type
  end

  def self.down
    remove_index :photo_sets, :page_type
  end
end
