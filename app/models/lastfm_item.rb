# == Schema Information
# Schema version: 29
#
# Table name: lastfm_items
#
#  id              :integer       not null, primary key
#  lastfm_chart_id :integer       not null
#  position        :integer       not null
#  name            :string(255)   
#

class LastfmItem < ActiveRecord::Base
  belongs_to :lastfm_chart
  validates_uniqueness_of :name, 
                          :scope => 'lastfm_chart_id', 
                          :message => 'The same name should appear twice in the same chart.'
  
  def to_liquid
    self
  end
end
