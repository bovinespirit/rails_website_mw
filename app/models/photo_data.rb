# This is hidden away in the bowels of Photo
class PhotoData < ActiveRecord::Base
  set_table_name 'photo_data'
  belongs_to :photo
end
