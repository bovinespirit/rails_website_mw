class DropDataColumn < ActiveRecord::Migration
  def self.up
    remove_column(:photos, 'data')
  end

  def self.down
    add_column(:photos, 'data', :binary)
  end
end
