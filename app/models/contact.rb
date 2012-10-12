# == Schema Information
# Schema version: 29
#
# Table name: contacts
#
#  id           :integer       not null, primary key
#  updated_at   :datetime      
#  method_name  :string(255)   
#  fn           :string(255)   
#  organisation :boolean       
#  xfn          :string(255)   
#  href         :string(255)   
#

class Contact < ActiveRecord::Base
  validates_uniqueness_of :fn
  validates_uniqueness_of :method_name
  validates_length_of :fn, :in => 2..255

  def fn_class
    "fn" + (organisation ? " org" : "")
  end

  def to_liquid
    {:href => href, :fn => fn, :xfn => xfn, :fn_class => fn_class, :rev => updated_on}
  end
end
