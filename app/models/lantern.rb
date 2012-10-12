# == Schema Information
# Schema version: 29
#
# Table name: lanterns
#
#  id              :integer       not null, primary key
#  name            :string(255)   default("NEW LANTERN"), not null
#  weight          :float         
#  lantern_type_id :integer       default(1), not null
#  manufacturer_id :integer       
#

class Lantern < ActiveRecord::Base
  has_many :beam_angles, :dependent => :destroy
  has_many :currents, :dependent => :destroy
  has_many :dmx_channels, :dependent => :destroy, :order => :channels
  belongs_to :manufacturer
  belongs_to :lantern_type
  has_and_belongs_to_many :gobo_wheels, :include => :gobo_wheel_type, :order => :name
  has_and_belongs_to_many :error_messages
  has_and_belongs_to_many :lamps
  has_and_belongs_to_many :notes

  validates_presence_of :name, :weight
  validates_uniqueness_of :name, :scope => 'manufacturer_id'
  validates_numericality_of :weight
  validates_length_of :name, :maximum => 255
  validates_format_of :name, :with => /^\w[\w ]*\w$/

   def validate
    if !weight.blank?
      errors.add(:weight, "must be greater than 0") unless weight > 0
    end
  end
end
