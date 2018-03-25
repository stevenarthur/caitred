class RenameEmailColumnsForSupplierCommunications < ActiveRecord::Migration
  def change
    remove_column :supplier_communications, :from
    remove_column :supplier_communications, :to
    add_column :supplier_communications, :from_name, :string, null: false
    add_column :supplier_communications, :from_email, :string, null: false
    add_column :supplier_communications, :to_name, :string, null: false
    add_column :supplier_communications, :to_email, :string, null: false
  end
end
