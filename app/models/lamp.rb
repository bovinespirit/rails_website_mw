# == Schema Information
# Schema version: 29
#
# Table name: lamps
#
#  id              :integer       not null, primary key
#  name            :string(255)   default(""), not null
#  power           :integer       default(0), not null
#  life            :integer       
#  temp            :integer       
#  manufacturer_id :integer       
#

class Lamp < ActiveRecord::Base
  belongs_to :manufacturer
  has_and_belongs_to_many :lanterns

  validates_length_of :name, :maximum => 255
  validates_uniqueness_of :name, :scope => :manufacturer_id
  validates_inclusion_of :power, :in => 0..10000
  validates_inclusion_of :temp, :in => 100..10000, :if => Proc.new { |r| !r.temp.blank? }
  validates_inclusion_of :life, :in => 10..100000, :if => Proc.new { |r| !r.life.blank? }
  validates_format_of :name, :with => /^\w[\w \/\-]*\w$/
end
