class LoseOldPhotoColumns < ActiveRecord::Migration
  def self.up
    remove_column :photos, 'position'
    remove_column :photos, 'photo_set_id'
    remove_column :photo_sets, 'method'
  end

  def self.down
    add_column :photos, 'position', :integer
    add_column :photos, 'photo_set_id', :integer
    add_column :photo_sets, 'method', :string
  end
end
