class AddUuidForCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :customer_id, :uuid, default: 'uuid_generate_v4()'
    add_column :enquiries, :customer_id_new, :uuid
    add_column :addresses, :customer_id_new, :uuid
  end
end
