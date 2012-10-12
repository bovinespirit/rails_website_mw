# == Schema Information
# Schema version: 29
#
# Table name: photo_sets
#
#  id                :integer       not null, primary key
#  page_id           :integer       default(0)
#  page_type         :string(255)   
#  contents_photo_id :integer       
#

class PhotoSet < ActiveRecord::Base
  has_many :photos_photo_sets, :dependent => :destroy, 
                               :order => 'photos_photo_sets.position'
  has_many :photos, :through => :photos_photo_sets, 
                    :order => 'photos_photo_sets.position'
  has_many :redirections, :as => :targetable, :dependent => :nullify
  belongs_to :page, :polymorphic => true
  belongs_to :contents_photo, :class_name => 'Photo', :foreign_key => 'contents_photo_id'
  
  validates_uniqueness_of :page_id, :scope => :page_type, 
                          :message => 'There is a PhotoSet for this object already.',
                          :if => Proc.new { |ps| !ps.page.nil? }
  
  def to_param
    "#{id}-#{title.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=_+]+/, '-').gsub(/[\-]{2,}/, '-')}"
  end
  
  def validate
    unless self[:contents_photo_id].nil?
      errors.add('contents_photo', 'must be in the PhotoSet') if photos.find_by_id(self[:contents_photo_id]).nil?
    end
  end
  
  # Looks into the page object for title if title == nil
  # Bit of a hack to make old tests and stuff work
  def title
    if self[:title].nil? and !page.nil?
      self[:title] = page.title
      save
    end
    self[:title]
  end
  
  # Looks into page for uri
  def uri
    return nil if page.nil?
    page.uri
  end
  
  # Returns the contents Photo is it's been defined, otherwise returns the first photo, or nil
  def contents_photo
    ph = Photo.find_by_id(self[:contents_photo_id])
    ph ||= (photos.nil?) ? nil : photos.find(:first)
    ph
  end
  
  # Finds a PhotoSet for this object if it exists
  def self.find_by_obj(obj, opts = {})
    klass = find_klass(obj).to_s
    return nil unless count(:conditions => {:page_type => klass}) > 0
    return find_by_page_type_and_page_id(klass, obj[:id], opts)
  end
  
  # Creates a PhotoSet for an object
  def self.create_from(obj)
    ps = PhotoSet.new({:page_id => obj[:id], :page_type => find_klass(obj).to_s, :title => obj.title})
    ps.save!
    return ps
  end
  
  def to_liquid
    self
  end
  
  def add_photo(photo)
    photos_photo_sets.create(:photo => photo)
  end
  
  def insert_photo(photo, position)
    pps = photos_photo_sets.create(:photo => photo)
    pps.insert_at(position)
  end
  
  def move_photo(photo, position)
    pps = photos_photo_sets.find_by_photo_id(photo.id)
    pps.insert_at(position)
  end    
  
  def add_photo_set(ps, reorder = false)
    pos = photos.count + 1
    photos_photo_sets.each do |pps|
      if ps.photos_photo_sets.count(:conditions => ['photo_id=?', pps.photo_id]) > 0
        pos = pps.position
        break if reorder
      end
    end
    pos += 1 unless reorder
    ps.photos.find(:all, :order => 'photos_photo_sets.position DESC').each do |photo|
      if photos_photo_sets.count(:conditions => ['photo_id=?', photo.id]) > 0
        move_photo(photo, pos) if reorder
      else
        insert_photo(photo, pos)
      end
    end
  end
  
  def tag_photos(tag)
    photos.each do |photo|
      photo.tags << tag unless photo.tags.count(:conditions => {:id => tag.id}) > 0
    end
  end
  
  protected
  def self.find_klass(obj)
    klass = obj.class
    klass = ComatosePage if klass == Comatose::PageWrapper
    return klass
  end
end
