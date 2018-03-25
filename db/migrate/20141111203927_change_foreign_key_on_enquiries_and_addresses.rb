class ChangeForeignKeyOnEnquiriesAndAddresses < ActiveRecord::Migration
  def up
    remove_column :addresses, :customer_id, :integer
    rename_column :addresses, :customer_id_new, :customer_id
    remove_column :enquiries, :customer_id, :integer
    rename_column :enquiries, :customer_id_new, :customer_id
    rename_column :customers, :id, :id_number
    rename_column :customers, :customer_id, :id
    execute 'ALTER TABLE customers DROP CONSTRAINT customers_pkey'
    execute 'ALTER TABLE customers ADD PRIMARY KEY(id)'
    change_table :enquiries do |t|
      t.foreign_key :customers
    end
    change_table :addresses do |t|
      t.foreign_key :customers
    end
  end

  def down
    rename_column :addresses, :customer_id, :customer_id_new
    add_column :addresses, :customer_id, :integer
    rename_column :enquiries, :customer_id, :customer_id_new
    add_column :enquiries, :customer_id, :integer
    rename_column :customers, :id, :customer_id
    rename_column :customers, :id_number, :id
    execute 'ALTER TABLE customers DROP CONSTRAINT customers_pkey'
    execute 'ALTER TABLE customers ADD PRIMARY KEY(id)'
  end
end
