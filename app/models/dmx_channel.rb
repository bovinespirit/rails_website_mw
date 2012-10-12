# == Schema Information
# Schema version: 29
#
# Table name: dmx_channels
#
#  id          :integer       not null, primary key
#  lantern_id  :integer       not null
#  mode        :string(255)   default("DMX"), not null
#  channels    :integer       default(0), not null
#  description :string(255)   
#

class DmxChannel < ActiveRecord::Base
  belongs_to :lantern

  validates_uniqueness_of :mode, :scope => "lantern_id", :message => "must be unique for this lantern"
  validates_numericality_of :channels, :only_integer => true
  validates_length_of :mode, :maximum => 255
  validates_length_of :description, :maximum => 255
  validates_format_of :mode, :with => /^\w[\w _\-\.]*\w$/
  validates_format_of :description, :with => /^(\w[\w _,\(\)\-\.\/\\:]*\w)?$/

end
