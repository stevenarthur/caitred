class CreateEnquiryItems < ActiveRecord::Migration
  def change
    create_table :enquiry_items do |t|
      t.references :enquiry, index: true, foreign_key: true
      t.references :packageable_item, index: true, foreign_key: true
      t.decimal :unit_price, precision: 8, scale: 2
      t.integer :quantity
      t.decimal :total_price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
