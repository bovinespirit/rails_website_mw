class AddVagueDateToPhoto < ActiveRecord::Migration
  def self.up
    add_column(:photos, 'vague_created_date', :boolean, :default => false)
  end

  def self.down
    remove_column(:photos, 'vague_created_date')
  end
end
