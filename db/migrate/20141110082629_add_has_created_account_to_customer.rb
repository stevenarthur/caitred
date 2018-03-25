class AddHasCreatedAccountToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :created_account, :boolean, null: false, default: false
  end
end
