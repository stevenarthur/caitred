class SetUuidForEnquiriesAndAddresses < ActiveRecord::Migration
  def change
    Enquiry.all.each do |enquiry|
      enquiry.customer_id_new = enquiry.customer.customer_id
    end
    Address.all.each do |address|
      address.customer_id_new = address.customer.customer_id
    end
    change_table :enquiries do |t|
      t.foreign_key :customers, name: 'customer_id_new'
    end
    change_table :addresses do |t|
      t.foreign_key :customers, name: 'customer_id_new'
    end
  end
end
