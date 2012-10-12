class AddPhotoIdToPhotoData < ActiveRecord::Migration
  def self.up
    add_column(:photo_data, :photo_id, :integer)
    add_index(:photo_data, :photo_id)
    
    PhotoSet.reset_column_information    

    PhotoData.find(:all).each do |pd|
      pd[:photo_id] = pd[:id]
      pd.save!
    end
  end

  def self.down
    remove_column(:photo_data, :photo_id)
  end
end
