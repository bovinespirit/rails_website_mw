class AddMenuNameToComatose < ActiveRecord::Migration
  def self.up
    add_column(:comatose_pages, "menu_title", :string)
  end

  def self.down
    remove_column :comatose_pages, "menu_title"
  end
end
