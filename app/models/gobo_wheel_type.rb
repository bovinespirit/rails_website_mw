# == Schema Information
# Schema version: 29
#
# Table name: gobo_wheel_types
#
#  id   :integer       not null, primary key
#  name :string(255)   default("New Wheel"), not null
#

class GoboWheelType < ActiveRecord::Base
  has_many :gobo_wheels, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^\w[\w ]*\w$/
  validates_length_of :name, :maximum => 255
end
