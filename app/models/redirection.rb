# == Schema Information
# Schema version: 29
#
# Table name: redirections
#
#  id              :integer       not null, primary key
#  uri             :string(255)   
#  targetable_id   :integer       
#  targetable_type :string(255)   
#

require 'faster_csv'

class Redirection < ActiveRecord::Base
  belongs_to :targetable, :polymorphic => true
  validates_uniqueness_of :uri
  
  class << self  
    # Returns a uri for the correct page, or nil if there is none
    def redirect(uri)
      wb = webpage(uri)
      return wb.uri unless wb.nil?
      nil
    end
    
    # Returns the Webpage object for a uri
    def webpage(uri)
      return nil if uri.nil?
      re = Redirection.find_by_uri(uri)
      return nil if re.nil?
      return re.webpage
    end
    
    # Find redirects that do not point to anything
    def find_targetless(options = {})
      return Redirection.find_all_by_targetable_id(nil, options)
    end
    
    def read_google_csv(file)
      FasterCSV.parse(file.read, {:headers => :first_row, :skip_blanks => true }) do |row|
        if row.field_row?
          uri = row.field('URL').gsub("http:\/\/www\.matthewwest.co.uk", '')
          re = Redirection.new { |r| r.uri = uri }
          re.save! if re.valid?
        end
      end
    end    
  end

  def webpage
    Webpage.from(targetable)
  end
end
