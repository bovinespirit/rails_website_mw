class LastFmTables < ActiveRecord::Migration
  def self.up
    create_table :lastfm_charts do |t|
      t.column :from, :datetime
      t.column :overall, :boolean
      t.column :most_recent, :boolean
    end
    create_table :lastfm_items do |t|
      t.column :lastfm_chart_id, :integer, :null => false
      t.column :position, :integer, :null => false
      t.column :name, :string
    end    
  end

  def self.down
    drop_table :lastfm_charts
    drop_table :lastfm_items
  end
end
