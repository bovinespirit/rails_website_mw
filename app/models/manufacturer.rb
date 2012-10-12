# == Schema Information
# Schema version: 29
#
# Table name: manufacturers
#
#  id   :integer       not null, primary key
#  www  :string(255)   
#  name :string(255)   not null
#

class Manufacturer < ActiveRecord::Base
  has_many :lanterns, :dependent => :destroy, :order => "name"
  has_many :gobos, :dependent => :destroy, :order => "number, name"
  has_many :lamps, :dependent => :destroy, :order => "name"

  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 255
  validates_length_of :www, :maximum => 255
  validates_format_of :name, :with => /^\w[\w ]*\w$/
  validates_format_of :www, :with => /^\w+\.[\-\w\.]+\.\w+$/

  def self.lantern_makers
# Returns array of Lantern manufacturers
    ma = Manufacturer.find(:all, :conditions => "manufacturers.id = lanterns.manufacturer_id", 
                           :include => :lanterns, 
                           :order => "manufacturers.name")
    ma.each { |m| m.lanterns.sort! { |x, y| x.name <=> y.name } }
    return ma
  end
end
