class CreateRedirections < ActiveRecord::Migration
  def self.up
    create_table :redirections do |t|
      t.column 'uri', :string
      t.column 'targetable_id', :integer
      t.column 'targetable_type', :string
    end
  end

  def self.down
    drop_table :redirections
  end
end
