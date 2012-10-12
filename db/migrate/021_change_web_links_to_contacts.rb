class ChangeWebLinksToContacts < ActiveRecord::Migration
  def self.up
    drop_table :web_links
    create_table :contacts do |t|
      t.column :updated_at, :datetime
      t.column :method, :string
      t.column :fn, :string
      t.column :organisation, :boolean, :default => false
      t.column :xfn, :string
      t.column :href, :string
    end    
  end

  def self.down
    drop_table :contacts
    create_table :web_links do |t|
      t.column :method, :string
      t.column :name, :string
      t.column :href, :string
      t.column :description, :string
    end
  end
end
