class UpgradeToComatoseV07 < ActiveRecord::Migration

  # Upgrades schema from version 0.6 to version 0.7 
  def self.up
    add_column :comatose_pages, "version", :integer
    Comatose::Page.create_versioned_table
  end

  # Downgrades schema from version 0.7 to version 0.6
  def self.down
    Comatose::Page.drop_versioned_table
    remove_column :comatose_pages, "version"
  end

end
