class RemoveTagCount < ActiveRecord::Migration
  # Remove taggings_count column.  New acts_as_taggable_on_steroids does it without the column.
  def self.up
    remove_column :tags, 'taggings_count'
  end

  def self.down
    add_column :tags, 'taggings_count', :integer
  end
end
