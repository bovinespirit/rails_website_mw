class AddAndPopulatePhotoDataTable < ActiveRecord::Migration
  def self.up
    create_table :photo_data do |t|
      t.column 'data', :binary, :null => false      
    end
    Photo.find(:all).each do |photo|
      say "Transferring #{photo.title}"
      say photo.data.to_s[0..10]
      data = ''
      photo.data.to_s.each_byte { |c| data << sprintf('\\\\%03o', c) }
      say data[0..10]
      Photo.connection.execute("INSERT INTO photo_data (id, data) VALUES (#{photo.id}, '#{data}')")
    end
  end

  def self.down
    drop_table :photo_data
  end
  
end
