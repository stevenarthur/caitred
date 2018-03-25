class AddAdditionalContactToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :additional_first_name, :string
    add_column :customers, :additional_last_name, :string
    add_column :customers, :additional_email, :string
    add_column :customers, :additional_telephone, :string
  end
end
