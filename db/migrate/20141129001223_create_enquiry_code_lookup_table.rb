class CreateEnquiryCodeLookupTable < ActiveRecord::Migration
  def change
    create_table :enquiry_codes do |t|
      t.integer :enquiry_id, null: false
      t.string :code, null: false
      t.string :code_type, null: false
    end

    change_table :enquiry_codes do |t|
      t.foreign_key :enquiries
    end

    add_index :enquiry_codes, [:code, :code_type]
  end
end
