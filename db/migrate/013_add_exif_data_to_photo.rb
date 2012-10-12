class AddExifDataToPhoto < ActiveRecord::Migration
  def self.up
    add_column(:photos, 'camera_model', :string, :default => 'No data')
    add_column(:photos, 'aperture', :float, :default => '0')
    add_column(:photos, 'exposure', :string, :default => 'No data')
    add_column(:photos, 'focal_length', :float, :default => '0')
    add_column(:photos, 'metering', :string, :default => 'No data')
    add_column(:photos, 'processed_with_gimp', :boolean, :default => 'false')
  end
  
  def self.down
    remove_column(:photos, 'camera_model')
    remove_column(:photos, 'aperture')
    remove_column(:photos, 'exposure')
    remove_column(:photos, 'focal_length')
    remove_column(:photos, 'metering')
    remove_column(:photos, 'processed_with_gimp')
  end
end
