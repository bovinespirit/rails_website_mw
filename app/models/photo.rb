# == Schema Information
# Schema version: 29
#
# Table name: photos
#
#  id                  :integer       not null, primary key
#  title               :string(255)   
#  slug                :string(255)   
#  description         :string(255)   
#  updated_on          :datetime      
#  created_on          :datetime      
#  text                :text          
#  thumb_x             :integer       default(0)
#  thumb_y             :integer       default(0)
#  thumb_l             :integer       default(0)
#  thumb_vertical      :boolean       
#  width               :integer       default(0)
#  height              :integer       default(0)
#  camera_model        :string(255)   default("No data")
#  aperture            :float         default(0.0)
#  exposure            :string(255)   default("No data")
#  focal_length        :float         default(0.0)
#  metering            :string(255)   default("No data")
#  processed_with_gimp :boolean       
#  vague_created_date  :boolean       
#

# Sizes:
# # a and b must be even or thumb_cards won't line up properly.
# a = SHORT_EDGE
# b = LONG_EDGE
# EDGE_RATIO = b/a = 1.4142
# 
#  b x a     127x90   127x89     84x60    82x58
# 2a x b     180x127  178x125    120x84   116x82
# 2b x 2a    254x180  250x176    168x120  164x116
# 4a x 2b    360x254  352x248    240x168  232x164
# 4b x 4a    508x360  496x350    336x240  328x232
#                                480x336  464x328
#                                          ^ For 'black' theme, to make 'portfolio' fit on the 800px column
#                                 ^ New attempt, with extra small size and rounding
#                      ^ These are the figures that actually work, as to_i doesn't round properly
# 
# 
require 'RMagick'

class Photo < ActiveRecord::Base
  EDGE_RATIO = 1.4142
  PADDING = 8
  THUMB_SIZES = {'xxsmall' => [82, 58],
                 'xsmall' => [116, 82],
                 'small' => [164, 116],
                 'medium' => [232, 164],
                 'large' => [328, 232],
                 'xlarge'=> [464, 328]}.freeze
  COLORIZE_LEVEL = 0.6
  IMAGE_SIZE = "700x700"

  class InvalidImage < ArgumentError #:nodoc:
  end
  @@invalid_image_message = 'must be a valid image file, such as JPG, GIF or PNG'

  has_many :redirections, :as => :targetable, :dependent => :nullify
  has_many :photos_photo_sets, :dependent => :destroy
  has_many :photo_sets, :through => :photos_photo_sets
  has_many :contents_photos, :class_name => 'PhotoSet', :foreign_key => 'contents_photo_id', :dependent => :nullify
  has_one  :photo_data, :dependent => :destroy

  acts_as_taggable
  
  validates_presence_of :thumb_x, :thumb_y, :thumb_l
  validates_length_of :title, :maximum => 255
  validates_numericality_of :thumb_x, :only_integer => true
  validates_numericality_of :thumb_y, :only_integer => true
  validates_numericality_of :thumb_l, :only_integer => true
  
  attr_protected :width, :height
  attr_reader :meta_info
  
  before_validation :set_thumbnail_size
  
  before_validation do |record|
    if (record[:slug].nil? or record[:slug].empty?) and !record[:title].nil?
      record[:slug] = record[:title].downcase.gsub( /[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=_+]+/, '-').gsub(/[\-]{2,}/, '-').to_s
    end
  end
  
  def validate()
    tw, th = size(thumb_l)
    if ((thumb_x + tw) > width) or ((thumb_y + th) > height)
      errors.add(:thumb_l, "Thumbnail area is outside image")
    end
    errors.add :data, @@invalid_image_message if @invalid_image
  end
  
  def to_param
    if has_title?
      "#{id}-#{title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=_+]+/, '-').gsub(/[\-]{2,}/, '-')}"
    else
      "#{id}"
    end
  end 
  
  before_save do |record|
    record.attributes = record.meta_info
    record[:updated_on] = Time.now
  end
  
  def after_initialize
    @meta_info = {}
    @invalid_image = false
    @data_store = nil
  end
  
  def size(szstr = nil)
    if !szstr
      [self[:width], self[:height]]
    else
      Photo::thumb_size(szstr, self[:thumb_vertical])
    end
  end
  
  # Resize the image to a thumbnail size
  # sizestr is a String name of a thumbnail size
  # e.g. 'small'
  def resize_thumb(sizestr)
    ret = nil
    if THUMB_SIZES.has_key?(sizestr)
      sw, sh = size(sizestr)
      img = Magick::Image.from_blob(data)[0]
      tw, th = size(thumb_l)
      img.crop!(thumb_x, thumb_y, tw, th)
      img.resize!(sw, sh)
      ret = img.to_blob
    else
      ret = data
    end
    GC.start
    ret
  end
  
  # Returns the size of a thumbnail as an array [X, Y]
  # size is either
  #   Integer = length of the long edge
  #   String = Name of a size defined in THUMB_SIZES
  # If vertical is true Y is the long edge, otherwise X is
  def self.thumb_size(size, vertical = false)
    if size.is_a?(String)
      if THUMB_SIZES[size]
        long, short = THUMB_SIZES[size]
      else
        return nil
      end
    elsif size.is_a?(Integer)
      long = size
      short = (long.to_f / EDGE_RATIO).to_i
    else
      return nil
    end
    short -= PADDING
    long -= PADDING
     (vertical == true) ? [short, long] : [long, short]
  end
  
  def self.find_size_by_slug(slug)
    Photo.find_by_slug(slug, :select => 'id, title, slug, width, height, thumb_x, thumb_y, thumb_l, thumb_vertical')
  end
  
  # Overloads assignment to the :data attribute.  Converts .jpg into blob, reads width and height
  # Uses get_exif_info to read other data.
  def data=(file)
    return nil unless file.size > 0
    begin
      @invalid_image = false
      raise InvalidImage, 'Uploaded file contains no binary data.  Be sure that {:multipart => true} is set on your form.' unless file.respond_to?(:read)     
      img = Magick::Image.from_blob(file.read)[0]
      raise InvalidImage, 'from_blob method on file returned nil.  Invalid format.' if img.nil?
      img.format = 'JPG'
      img.change_geometry!(IMAGE_SIZE) {|cols, rows, i| i.resize!(cols, rows)}
      create_photo_data() if photo_data.nil?
      photo_data.data = img.to_blob
      photo_data.save!
      self.attributes = get_exif_info(img)
      self[:width] = img.columns
      self[:height] = img.rows
    rescue => e
      @invalid_image = true
      logger.error(e.to_s)
    ensure
      GC.start
    end
    @invalid_image ? nil : photo_data.data
  end
  
  # Return data that is hidden in photo_data
  def data
    return nil if photo_data.nil?
    return photo_data.data
  end
  
  def has_data?
    return data != nil
  end
  
  def exif_image=(file)
    if file.size > 0
      begin
        raise InvalidImage, 'Uploaded file contains no binary data.  Be sure that {:multipart => true} is set on your form.' unless file.respond_to?(:read)     
        img = Magick::Image.from_blob(file.read)[0]
        raise InvalidImage, 'from_blob method on file returned nil.  Invalid format.' if img.nil?
        img.format = 'JPG'
        @meta_info = get_exif_info(img)
      rescue
        @meta_info = {}
        @invalid_image = true
      ensure
        GC.start
      end
    end
  end
  
  def exif_image()
    return nil
  end
  
  # Returns a 'blob' object that is the background to a captioned image
  def make_bg(bg_size = nil)
    begin
      img = Magick::Image.from_blob(resize_thumb(bg_size))[0]
      img.quantize.colorize(COLORIZE_LEVEL, COLORIZE_LEVEL, COLORIZE_LEVEL, '#d2f0ff').to_blob
    ensure
      GC.start
    end
  end
  
  # Acts as list bits for Photos in PhotoSets
  # Photos can be in many different photo_sets
  # so the photo_set must be provided
  
  def first?(photo_set)
    return ppsjoin(photo_set).first? 
  end
  
  def last?(photo_set)
    return ppsjoin(photo_set).last?
  end
  
  # miss is an optional Photo to be skipped
  #   i.e. the current photo in the carousel
  def prev(photo_set, miss = {:id => 0})
    return nil if first?(photo_set)
    res = ppsjoin(photo_set).higher_item.photo
    return nil if res.nil?
    return res.prev(photo_set) if res[:id] == miss[:id]
    return res
  end
  
  def next(photo_set, miss = {:id => 0})
    return nil if self.last?(photo_set)
    res = ppsjoin(photo_set).lower_item.photo
    return nil if res.nil?
    return res.next(photo_set) if res[:id] == miss[:id]
    return res
  end
  
  def move_up(photo_set)
    ppsjoin(photo_set).move_higher
  end
  
  def move_down(photo_set)
    ppsjoin(photo_set).move_lower
  end
  
  def position(photo_set)    
    ppsjoin(photo_set).position
  end
  
  def remove_from(photo_set)
    ppsjoin(photo_set).destroy
  end
  
  def self.find_homeless
    # pi is an array of photo_id's in photos_photo_sets
    pi = PhotosPhotoSet.find(:all, :select => 'id, photo_id', 
    :group => 'photos_photo_sets.id, photo_id').collect { |pps| pps.photo_id }
    # Find all Photos whose id is not in pi
    Photo.find(:all, :conditions => ['id NOT IN (?)', pi], :order => 'title')
  end
  
  def self.find_all_but_photo_set(photo_set)
    pi = photo_set.photos.collect { |photo| photo.id }
    conditions = (pi.empty?) ? {} : { :conditions => ['id NOT IN (?)', pi] }
    Photo.find(:all, { :order => 'title' }.merge(conditions))
  end
  
  def title=(value)
    self[:title] = (value.nil? or value.empty? or value == title_string) ? nil : value
  end
  
  def title
    return has_title? ? self[:title] : title_string
  end
  
  def has_title?
    return !(self[:title].nil? or self[:title].empty? or self[:title] == title_string)
  end
  
  # This takes a hash of photo_set IDs like:
  # { '1' => '1', '23' => '1', '45' => '1' }
  # Any photo_sets missing are unlinked
  def alter_photo_sets(params)
    ids = params.keys.collect { |k| k.to_i }
    del = []
    photo_sets.each do |ps|
      if ids.include?(ps.id.to_i)
        ids.delete(ps.id)
      else
        del << ps
      end
    end 
    del.each { |ps| photo_sets.delete(ps) }
    ids.each { |i| PhotoSet.find(i).add_photo(self) }
  end
  
  # I don't want the AR magic timestamping support for this class...
  def record_timestamps
    false
  end
  
  def self.record_timestamps
    false
  end
  
  private
  def title_string
    "Photo #{self[:id]}"
  end
  
  METERING_MODES = {
            '0' => 'Unknown',
            '1' => 'Average',
            '2' => 'Center Weighted Average',
            '3' => 'Spot',
            '4' => 'Multi-Spot',
            '5' => 'Multi-Segment',
            '6' => 'Partial'}.freeze()
  
  # Canon gives focal length as x/32, aperture as x/y
  # split_div converts numbers to floats before dividing
  def split_div(str)
    str =~ /(\d+)\/(\d+)/
    if $1 and $2
      result = $1.to_f / $2.to_f
      result.to_s.gsub(/\.(\d)\d*/) { |s| "."+$1 }
    else
      str
    end
  end
  
  # Reads exif info in a Magick:Image
  # Returns a hash
  def get_exif_info(img)
    res = {}
    res[:camera_model] = img.get_exif_by_entry("Model")[0][1] || 'No data'
    # Removes trailing full stop that Canon insist on putting in 
    res[:camera_model].gsub!(/\.\Z/, '')
    res[:exposure] = img.get_exif_by_entry("ExposureTime")[0][1] || 'No data'
    res[:aperture] = split_div(img.get_exif_by_entry("FNumber")[0][1]) || 0
    res[:focal_length] = split_div(img.get_exif_by_entry("FocalLength")[0][1]) || 0
    res[:metering] = METERING_MODES[img.get_exif_by_entry("MeteringMode")[0][1]] || 'No data'
    if otime = img.get_exif_by_entry("DateTimeOriginal")[0][1]
      begin
        res[:created_on] = DateTime.strptime(otime[0..18], "%Y:%m:%d %H:%M:%S").to_date
      rescue ArgumentError
      # Cheap ass photo scans didn't store date properly
        res.delete(:created_on)
      end
    end
    res
  end
  
  # Returns the PhotosPhotoSet object for thi Photo and the pased PhotoSet
  def ppsjoin(photo_set)
    raise "photo_set must be of type PhotoSet" unless photo_set.is_a?(PhotoSet)
    pps = photos_photo_sets.find_by_photo_set_id(photo_set.id)
    raise "This photo is not part of " + photo_set.title if pps.nil?
    pps
  end
  
  def set_thumbnail_size
    return if (self.thumb_x != 0 or self.thumb_y != 0 or self.thumb_l != 0)
    self.thumb_x = self.thumb_y = 0
    self.thumb_vertical = height > width
    self.thumb_l = (thumb_vertical) ? height : width
    tw, th = size(thumb_l)
    if tw > width or th > height
      self.thumb_l = (thumb_vertical) ? width : height
    end
  end
end
