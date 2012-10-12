class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :title, :string
      t.column :body, :text
      t.column :staging, :boolean, :default => true
    end
  end

  def self.down
    drop_table :posts
  end
end
