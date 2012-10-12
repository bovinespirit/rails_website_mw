# == Schema Information
# Schema version: 29
#
# Table name: lantern_types
#
#  id   :integer       not null, primary key
#  name :string(255)   default(""), not null
#

class LanternType < ActiveRecord::Base
  has_many :lantern, :dependent => :destroy

  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 255
  validates_format_of :name, :with => /^\w[\w ]*\w$/
end
