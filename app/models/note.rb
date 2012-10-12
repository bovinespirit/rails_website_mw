# == Schema Information
# Schema version: 29
#
# Table name: notes
#
#  id    :integer       not null, primary key
#  title :string(255)   default("Title"), not null
#  note  :text          not null
#

class Note < ActiveRecord::Base
  has_and_belongs_to_many :lanterns

  validates_presence_of :title, :note
  validates_length_of :title, :maximum => 255
  validates_format_of :title, :with => /^\w[\w ,\.:;\\\/\?\-\(\)!]*[\w\.\)\?!]+$/
  validates_format_of :note, :with => /^\w[\w ,\.:;\\\/\?\-\(\)!]*[\w\.\)\?!]+$/
end
