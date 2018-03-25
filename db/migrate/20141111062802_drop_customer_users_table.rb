class DropCustomerUsersTable < ActiveRecord::Migration
  def change
    drop_table :customer_users
  end
end
