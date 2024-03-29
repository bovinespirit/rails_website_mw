class AddTagSupport < ActiveRecord::Migration
  def self.up
    #Table for your Tags
    create_table :tags do |t|
      t.column :name, :string
      t.column :taggings_count, :integer, :default => 0
    end
    
    create_table :taggings do |t|
      t.column :tag_id, :integer
      #id of tagged object
      t.column :taggable_id, :integer
      #type of object tagged
      t.column :taggable_type, :string
      # with_steroids
      t.column :created_at, :datetime
    end
    
    # Index your tags/taggings
    add_index :tags, :name
    add_index :taggings, [:tag_id, :taggable_id, :taggable_type]
  end
  
  def self.down
    drop_table :tags
    drop_table :taggings
  end
end
