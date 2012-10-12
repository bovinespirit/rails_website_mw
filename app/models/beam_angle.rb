# == Schema Information
# Schema version: 29
#
# Table name: beam_angles
#
#  id         :integer       not null, primary key
#  lantern_id :integer       not null
#  minangle   :float         not null
#  maxangle   :float         not null
#  optional   :boolean       
#

# == Schema Information
# Schema version: 11
#
# Table name: beam_angles
#
#  lantern_id :integer       not null
#  minangle   :float         not null
#  maxangle   :float         not null
#  id         :integer       not null, primary key
#  optional   :boolean       
#
class BeamAngle < ActiveRecord::Base
  belongs_to :lantern

  validates_presence_of :maxangle, :minangle
  validates_numericality_of :maxangle, :minangle
  validates_inclusion_of :minangle, :in => 1..180, :message => "must be between 0 and 180"
  validates_inclusion_of :maxangle, :in => 1..180, :message => "must be between 0 and 180"
  validates_inclusion_of :optional, :in => [true, false], :message => "must be true or false"

  def optional_str
    return "Optional" if optional
    return "Standard"
  end

  def zoom?
    return maxangle != minangle
  end

  def validate
    errors.add(:maxangle, "must be greater than minimum angle") if maxangle < minangle
    idsql = ""
    idparams = []
    if !new_record?
      idsql = " AND id <> ?"
      idparams = [id]
    end
    if BeamAngle.count(:conditions => ["lantern_id = ? AND maxangle = ? AND minangle = ?" + idsql, lantern_id, maxangle, minangle, *idparams]) > 0
      errors.add(:lantern_id, "already has a lens like this")
    end
    if optional == false and BeamAngle.count(:conditions => ["lantern_id = ? AND optional = false" + idsql, lantern_id, *idparams]) > 0
      errors.add(:optional, "- there is already a standard lens for this lantern")
    end
  end
end
