class CreatePhotoSets < ActiveRecord::Migration
  def self.up
    create_table :photo_sets do |t|
      t.column :page_type, :integer, :default => 0 
      t.column :page_id, :integer, :default => 0
    end
    add_column(:photos, 'photo_set_id', :integer)
    remove_column(:photos, 'comatose_page_id')
  end

  def self.down
    drop_table :photo_sets
    remove_column :photos, 'photo_set_id'
    add_column(:photos, 'comatose_page_id', :integer)
  end
end
