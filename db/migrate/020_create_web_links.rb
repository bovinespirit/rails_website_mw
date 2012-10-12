class CreateWebLinks < ActiveRecord::Migration
  def self.up
    create_table :web_links do |t|
      t.column :method, :string
      t.column :name, :string
      t.column :href, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :web_links
  end
end
