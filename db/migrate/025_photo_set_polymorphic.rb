class PhotoSetPolymorphic < ActiveRecord::Migration
  def self.up
    remove_column :photo_sets, 'page_type'
    add_column :photo_sets, 'page_type', :string
    PhotoSet.reset_column_information
    PhotoSet.find(:all).each do |ps|
      ps.page_type = "Comatose::Page"
      ps.save!
    end
  end

  def self.down
    remove_column :photo_sets, 'page_type'
    add_column :photo_sets, 'page_type', :integer
    PhotoSet.reset_column_information
    PhotoSet.find(:all).each do |ps|
      ps.page_type = 1
      ps.save!
    end
  end
end
