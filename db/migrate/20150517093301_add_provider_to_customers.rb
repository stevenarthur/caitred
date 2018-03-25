class AddProviderToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :provider, :string
  end
end
