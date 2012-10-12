class AddManufacturer < ActiveRecord::Migration
  def self.up
    execute("CREATE TABLE manufacturers
             (
               id serial,
               www varchar(255),
               name varchar(255) NOT NULL,
               CONSTRAINT manufacturers_pkey PRIMARY KEY (id),
               CONSTRAINT manufacturers_name_key UNIQUE (name)
             )
             WITHOUT OIDS;
             ALTER TABLE manufacturers OWNER TO rails_dev;
             GRANT ALL ON TABLE manufacturers TO rails_dev;
             GRANT ALL ON TABLE manufacturers TO public;")
    add_column :gobos, :manufacturer_id, :integer
    add_column :lamps, :manufacturer_id, :integer
    add_column :lanterns, :manufacturer_id, :integer
  end

  def self.down
    execute("DROP TABLE manufacturers;")
    remove_column :gobos, :manufacturer_id
    remove_column :lamps, :manufacturer_id
    remove_column :lanterns, :manufacturer_id
  end
end
