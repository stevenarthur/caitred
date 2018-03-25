class AddContactMethodToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :contact_method, :string
  end
end
