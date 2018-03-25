class AddAdditionalFieldsToQuoteForm < ActiveRecord::Migration
  def change
    add_column :quotes, :event_type, :integer
    add_column :quotes, :date, :date
    add_column :quotes, :postcode, :integer
  end
end
