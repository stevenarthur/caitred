class RenameSupplierEnquiryTable < ActiveRecord::Migration
  def change
    rename_table :supplier_enquiries, :supplier_communications
  end
end
