class AddEmailTextToSupplierComms < ActiveRecord::Migration
  def change
    add_column :supplier_communications, :email_text, :string
  end
end
