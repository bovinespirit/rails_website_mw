class AddPhotoTable < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :data, :binary, :size => 10000000, :null => false
      t.column :title, :string, :length => 200
      t.column :slug, :string
      t.column :description, :string
      t.column :shade, :binary, :size => 10000000
      t.column :updated_on, :datetime
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :photos
  end
end
