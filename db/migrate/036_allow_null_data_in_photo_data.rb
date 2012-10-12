class AllowNullDataInPhotoData < ActiveRecord::Migration
  def self.up
    change_column(:photo_data, :data, :binary, {:null => true, :default => nil})
  end

  def self.down
    change_column(:photo_data, :data, :binary, :null => false)
  end
end
