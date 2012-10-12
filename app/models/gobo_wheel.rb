# == Schema Information
# Schema version: 29
#
# Table name: gobo_wheels
#
#  id                 :integer       not null, primary key
#  gobo_wheel_type_id :integer       not null
#  quantity           :integer       default(1), not null
#  gobo_size_id       :integer       not null
#  comment            :text          
#

class GoboWheel < ActiveRecord::Base
  belongs_to :gobo_size
  belongs_to :gobo_wheel_type

  has_and_belongs_to_many :lanterns
  has_many :gobo_wheels_gobos, :dependent => :destroy
  has_many :gobos, :through => :gobo_wheels_gobos, :order => :position

  validates_numericality_of :quantity
  validates_format_of :comment, :with => /^(\w[\w ,\.\:;\(\)\-]*[\w\)\.])?$/, :if => Proc.new { |r| !r.comment.blank? }

  def gobo(position)
    raise ActiveRecord::RecordNotFound if position < 1 or position > quantity
    gwg = gobo_wheels_gobos.find_by_position(position)
    return nil if !gwg
    return Gobo.find(gwg.gobo_id)
  end

  def set_gobo(position, gobo)
    raise ActiveRecord::RecordNotFound if position < 1 or position > quantity
    gwg = gobo_wheels_gobos.find_by_position(position)
    if !gwg
      gobo_wheels_gobos.create( :gobo_wheel => self,
                                :position => position,
                                :gobo => gobo)
    else
      gwg.gobo = gobo
      gwg.save
    end
  end

  def destroy_gobo(position)
    raise ActiveRecord::RecordNotFound if position < 1 or position > quantity
    gwg = gobo_wheels_gobos.find_by_position(position)
    gwg.destroy if gwg
  end
end
