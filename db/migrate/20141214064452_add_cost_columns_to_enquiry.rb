class AddCostColumnsToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :food_cost_to_us, :decimal, precision: 8, scale: 2
    add_column :enquiries, :delivery_cost_to_us, :decimal, precision: 8, scale: 2
    rename_column :enquiries, :cost_to_us, :total_cost_to_us
  end
end
