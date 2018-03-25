class AddCustomerMenuContentToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :customer_menu_content, :string
  end
end
