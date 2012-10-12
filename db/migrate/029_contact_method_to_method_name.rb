class ContactMethodToMethodName < ActiveRecord::Migration
  def self.up
    rename_column :contacts, 'method', 'method_name'
  end

  def self.down
    rename_column :contacts, 'method_name', 'method'
  end
end
