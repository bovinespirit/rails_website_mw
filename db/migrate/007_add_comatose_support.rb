class AddComatoseSupport < ActiveRecord::Migration

  # Schema for Comatose version 0.6
  def self.up
    create_table :comatose_pages do |t|
      t.column "parent_id", :integer
      t.column "full_path", :text
      t.column "title", :string, :limit => 255
      t.column "slug", :string, :limit => 255
      t.column "keywords", :string, :limit => 255
      t.column "body", :text
      t.column "filter_type", :string, :limit => 25, :default => "Textile"
      t.column "author", :string, :limit => 255
      t.column "position", :integer, :default => 0
      t.column "updated_on", :datetime
      t.column "created_on", :datetime
    end
    puts "Creating the default 'Home Page'..."
    Comatose::Page.create( :title=>'Home Page', :body=>"h1. Welcome\n\nYour content goes here...", :author=>'System' )
  end

  def self.down
    drop_table :comatose_pages
  end

end
