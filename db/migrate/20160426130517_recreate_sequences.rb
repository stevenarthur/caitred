class RecreateSequences < ActiveRecord::Migration
  # This fixes up the database after the data migrations from staging.
  def up
    execute <<-SQL
      CREATE SEQUENCE food_partners_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
      ALTER SEQUENCE food_partners_id_seq OWNED BY food_partners.id;

      CREATE SEQUENCE menu_categories_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
      ALTER SEQUENCE menu_categories_id_seq OWNED BY menu_categories.id;

      CREATE SEQUENCE packageable_items_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
      ALTER SEQUENCE packageable_items_id_seq OWNED BY packageable_items.id;

      CREATE SEQUENCE postcodes_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
      ALTER SEQUENCE postcodes_id_seq OWNED BY postcodes.id;
    SQL

    execute <<-SQL
      ALTER TABLE ONLY food_partners ALTER COLUMN id SET DEFAULT nextval('food_partners_id_seq'::regclass);
      ALTER TABLE ONLY menu_categories ALTER COLUMN id SET DEFAULT nextval('menu_categories_id_seq'::regclass);
      ALTER TABLE ONLY packageable_items ALTER COLUMN id SET DEFAULT nextval('packageable_items_id_seq'::regclass);
      ALTER TABLE ONLY postcodes ALTER COLUMN id SET DEFAULT nextval('postcodes_id_seq'::regclass);
      CREATE INDEX index_postcodes_on_delivery_area_id ON postcodes USING btree (delivery_area_id);
    SQL
  end
end
