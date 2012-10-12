# == Schema Information
# Schema version: 29
#
# Table name: photos_photo_sets
#
#  id           :integer       not null, primary key
#  photo_id     :integer       
#  photo_set_id :integer       
#  position     :integer       
#

class PhotosPhotoSet < ActiveRecord::Base
  belongs_to :photo
  belongs_to :photo_set
  acts_as_list :scope => :photo_set_id
  
  validates_uniqueness_of :photo_id, :scope => :photo_set_id
  
  class << self
    # Find the PhotosPhotoSet object for a certain Photo and PhotoSet
    def find_by_pps(photo, photo_set)
      find_by_pps_ids(photo.id, photo_set.id)
    end
    
    # Find the PhotosPhotoSet object for a certain Photo.id and PhotoSet.id
    def find_by_pps_ids(photo_id, photo_set_id)
      PhotosPhotoSet.find_by_photo_id_and_photo_set_id(photo_id, photo_set_id)
    end
  end
end
