class RemoveOldMakerTables < ActiveRecord::Migration
  def self.up
    execute("ALTER TABLE gobos DROP CONSTRAINT gobos_gobo_maker_id_fkey;")
    execute("ALTER TABLE lanterns DROP CONSTRAINT lanterns_lantern_maker_id_fkey;")
    execute("ALTER TABLE lamps DROP CONSTRAINT lamps_lamp_manufacturer_id_fkey;")

    remove_column :gobos, :gobo_maker_id
    remove_column :lamps, :lamp_manufacturer_id
    remove_column :lanterns, :lantern_maker_id

    drop_table :gobo_makers
    drop_table :lantern_makers
    drop_table :lamp_manufacturers
  end

  def self.down
  end
end
