class AddSubjectToSupplierComms < ActiveRecord::Migration
  def change
    add_column :supplier_communications, :email_subject, :string
  end
end
