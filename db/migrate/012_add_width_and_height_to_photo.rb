class AddWidthAndHeightToPhoto < ActiveRecord::Migration
  def self.up
    add_column(:photos, 'width', :integer, :default => 0)
    add_column(:photos, 'height', :integer, :default => 0)
    remove_column(:photos, 'shade')
  end

  def self.down
    remove_column(:photos, 'width')
    remove_column(:photos, 'height')
  end
end
