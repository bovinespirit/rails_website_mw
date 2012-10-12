# == Schema Information
# Schema version: 29
#
# Table name: gobos
#
#  id              :integer       not null, primary key
#  number          :string(10)    
#  description     :string(255)   default("- none -"), not null
#  manufacturer_id :integer       
#

class Gobo < ActiveRecord::Base
  belongs_to :manufacturer
  has_many :gobo_wheels_gobos, :dependent => :destroy
  has_many :gobo_wheels, :through => :gobo_wheels_gobos

  validates_uniqueness_of :description, :scope => :manufacturer_id
  validates_length_of :number, :maximum => 8, :if => Proc.new { |r| !r.number.blank? }
  validates_length_of :description, :maximum => 255

  validates_format_of :number, :with => /^\w([\w\-]*\w)?$/, :if => Proc.new { |r| !r.number.blank? }
  validates_format_of :description, :with => /^\w[\w \-@\';\/,\\:\(\)]*[\w\)]+$/
end
