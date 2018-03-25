class AddPaidColumnToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :paid, :boolean
  end
end
