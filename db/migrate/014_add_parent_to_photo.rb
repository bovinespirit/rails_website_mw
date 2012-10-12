class AddParentToPhoto < ActiveRecord::Migration
  def self.up
    add_column(:photos, 'comatose_page_id', :integer)
    add_column(:photos, 'position', :integer)
  end

  def self.down
    remove_column(:photos, 'position')
    remove_column(:photos, 'comatose_page_id')
  end
end
