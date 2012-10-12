# == Schema Information
# Schema version: 29
#
# Table name: gobo_sizes
#
#  id   :integer       not null, primary key
#  name :string(255)   default(""), not null
#

class GoboSize < ActiveRecord::Base
  has_many :gobo_wheels, :dependent => :destroy

  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  validates_format_of :name, :with => /^\w([\w \-]*\w)?$/
  validates_uniqueness_of :name
end
