class AddTitleToPhotoSet < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, 'title', :string
    PhotoSet.reset_column_information    
    PhotoSet.find(:all).each do |ps|
      ps.title = ps.page.title unless ps.page.nil?
      ps.save!
    end
  end

  def self.down
    remove_column :photo_sets, 'title'
  end
end
