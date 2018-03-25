class AddCompanyToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :company, :string
    remove_column :quotes, :event_type
  end
end
