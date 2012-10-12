# == Schema Information
# Schema version: 29
#
# Table name: gobo_wheels_gobos
#
#  id            :integer       not null, primary key
#  gobo_id       :integer       not null
#  gobo_wheel_id :integer       not null
#  position      :integer       not null
#

class GoboWheelsGobo < ActiveRecord::Base
  belongs_to :gobo_wheel
  belongs_to :gobo

  validates_numericality_of :position
end
