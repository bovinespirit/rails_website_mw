class ExpandPhotoWithTextAndCroppedImages < ActiveRecord::Migration
  def self.up
    add_column(:photos, 'text', :text)
    add_column(:photos, 'thumb_x', :integer, :default => 0)
    add_column(:photos, 'thumb_y', :integer, :default => 0)
    add_column(:photos, 'thumb_l', :integer, :default => 0)
    add_column(:photos, 'thumb_vertical', :boolean, :default => false)
  end

  def self.down
    remove_column(:photos, 'text')
    remove_column(:photos, 'thumb_x')
    remove_column(:photos, 'thumb_y')
    remove_column(:photos, 'thumb_l')
    remove_column(:photos, 'thumb_vertical')
  end
end
