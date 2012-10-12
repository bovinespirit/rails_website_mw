# == Schema Information
# Schema version: 29
#
# Table name: error_messages
#
#  id                :integer       not null, primary key
#  error             :string(16)    default("ERROR"), not null
#  name              :string(255)   default("name"), not null
#  short_description :string(255)   default("No Description"), not null
#  long_description  :text          
#

class ErrorMessage < ActiveRecord::Base
  has_and_belongs_to_many :lanterns

  validates_length_of :error, :maximum => 16, :message => "must be less then 16 characters"
  validates_length_of :name, :maximum => 255, :message => "must be less then 255 characters"
  validates_length_of :short_description, :maximum => 255, :message => "must be less then 255 characters"

  validates_format_of :error, :with => /^\w[\w \-\.\\:\/\@,]*\w$/
  validates_format_of :name, :with => /^\w[\w \-:;,\.]*\w$/
  validates_format_of :short_description, :with => /^\w[\w \-@\';\/,\\:\(\)\.]*[\w\.\)]+$/
  validates_format_of :long_description, :with => /^\w[\w \-@\';\/,\\:\(\)\.]*[\w\.\)]+$/
end
