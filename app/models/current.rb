# == Schema Information
# Schema version: 29
#
# Table name: currents
#
#  id         :integer       not null, primary key
#  lantern_id :integer       not null
#  voltage    :integer       default(230), not null
#  current    :float         not null
#  frequency  :integer       default(50), not null
#

class Current < ActiveRecord::Base
  belongs_to :lantern

  validates_numericality_of :voltage, :only_integer => true
  validates_numericality_of :frequency, :only_integer => true
  validates_numericality_of :current
  validates_inclusion_of :voltage, :in => 0...440, :message => "must be between 0V and 440V"
  validates_inclusion_of :current, :in => 0...120, :message => "must be between 0 and 120A"
  validates_inclusion_of :frequency, :in => 0..100, :message => "must be between 0 and 100Hz"

  def validate
    idsql = ""
    idparams = []
    if !new_record?
      idsql = " AND id <> ?"
      idparams = [id]
    end
    if Current.count(:conditions => ["lantern_id = ? AND voltage = ? AND frequency = ?" + idsql, 
                                     lantern_id, voltage, frequency, *idparams]) > 0
      errors.add(:lantern_id, "already has an entry with this voltage and frequency")
    end
    
  end
end
