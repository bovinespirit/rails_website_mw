module Comatose 
  class Page <  ComatosePage
    
  end
end

class Comatose2 < ActiveRecord::Migration
  def self.up
    rename_column :page_versions, :page_id, :comatose_page_id
    rename_table :page_versions, :comatose_page_versions
    
    Redirection.find(:all).each do |redirection|
      redirection.targetable_type = "ComatosePage" if redirection.targetable_type == "Comatose::Page"
      redirection.save!
    end
    PhotoSet.find(:all).each do |photo_set|
      photo_set.page_type = "ComatosePage" if photo_set.page_type == "Comatose::Page"
      photo_set.save!
    end
  end

  def self.down
    rename_column :comatose_page_versions, :comatose_page_id, :page_id
    rename_table :comatose_page_versions, :page_versions
    Redirection.find(:all).each do |redirection|
      redirection.targetable_type = "Comatose::Page" if redirection.targetable_type == "ComatosePage"
      redirection.save!
    end
    PhotoSet.find(:all).each do |photo_set|
      photo_set.page_type = "Comatose::Page" if photo_set.page_type == "ComatosePage"
      photo_set.save!
    end
  end
end
