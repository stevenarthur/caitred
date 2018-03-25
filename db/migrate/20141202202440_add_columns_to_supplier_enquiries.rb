class AddColumnsToSupplierEnquiries < ActiveRecord::Migration
  def change
    add_column :supplier_enquiries, :from, :string, null: false
    add_column :supplier_enquiries, :to, :string, null: false
  end
end
