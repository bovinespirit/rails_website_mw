class MigrateManufacturerData < ActiveRecord::Migration
  def self.up
    migrate_data(LanternMaker)
    migrate_data(GoboMaker)
    migrate_data(LampManufacturer)

    read_data(Gobo, "gobo_maker_id", GoboMaker)
    read_data(Lantern, "lantern_maker_id", LanternMaker)
    read_data(Lamp, "lamp_manufacturer_id", LampManufacturer)

    execute("ALTER TABLE gobos ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id) ON UPDATE CASCADE;")
    execute("ALTER TABLE lanterns ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)ON UPDATE CASCADE;")
    execute("ALTER TABLE lamps ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id) ON UPDATE CASCADE;")
  end

  def self.down
  end

  def self.migrate_data(tbl)
    tbl.find(:all).each do |c|
      i = Manufacturer.find_by_name(c.name)
      if i.blank?
        t = Manufacturer.new
        t.name = c.name
        if c.attribute_present?("www")
          t.www = c.www
        end
        t.save
      end
    end
  end

  def self.read_data(tbl, col, old)
    tbl.find(:all).each do |c|
      n = old.find(c[col])
      i = Manufacturer.find_by_name(n.name)
      c.manufacturer_id = i.id
      c.save
    end
  end
end
