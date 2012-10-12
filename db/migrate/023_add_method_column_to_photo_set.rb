class AddMethodColumnToPhotoSet < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, 'method', :string
  end

  def self.down
    remove_column :photo_sets, 'method'
  end
end
